// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

/// A [CommandRunner] that reports unknown sub commands also with `--help`.
///
/// `CommandRunner.runCommand` evaluates the `--help` flag before it looks at
/// the remaining positional arguments. Therefore `gg do xyz -h` prints the
/// usage of `do` and exits with 0 — the unknown »xyz« is swallowed. Only
/// without »-h« does it report the typo.
///
/// This runner closes that hole. Before delegating to [CommandRunner
/// .runCommand], it walks the command chain args has already parsed and
/// reports the first level that expects a sub command but got a positional
/// argument instead.
class UnknownSubCommandRunner extends CommandRunner<void> {
  /// Constructor
  UnknownSubCommandRunner(super.executableName, super.description);

  // ...........................................................................
  @override
  Future<void> runCommand(ArgResults topLevelResults) async {
    _throwOnUnknownSubCommand(topLevelResults);
    return super.runCommand(topLevelResults);
  }

  // ...........................................................................
  /// Throws a [UsageException] when the parse tree names an unknown sub command
  void _throwOnUnknownSubCommand(ArgResults topLevelResults) {
    var argResults = topLevelResults.command;
    var subCommands = commands;
    var commandString = executableName;

    while (argResults != null) {
      // Step into the command args has parsed
      final command = subCommands[argResults.name]!;
      commandString += ' ${argResults.name}';
      subCommands = command.subcommands;

      // A branch command without a sub command, but with a leftover
      // positional argument: that argument was meant to be a sub command.
      if (subCommands.isNotEmpty &&
          argResults.command == null &&
          argResults.rest.isNotEmpty) {
        command.usageException(
          'Could not find a subcommand named '
          '"${argResults.rest.first}" for "$commandString".',
        );
      }

      argResults = argResults.command;
    }
  }
}
