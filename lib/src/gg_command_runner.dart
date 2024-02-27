// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';
import 'package:colorize/colorize.dart';

/// A command runner that automatically forwards to a single sub command.
class GgCommandRunner {
  /// Constructor
  GgCommandRunner({
    required this.command,
    this.mainName,
    required this.description,
    required this.log,
  });

  // ...........................................................................
  /// Run the command
  Future<void> run({
    required List<String> args,
  }) async {
    final isSingleCommand = command.subcommands.isEmpty;

    // Single command? mainName must equal cmdName
    if (isSingleCommand && mainName != null && mainName != command.name) {
      throw ArgumentError(
        'If command has only one sub command, '
        'command name must be the same as sub command name!',
      );
    }

    // Not a single command? mainName must equal cmdName
    if (!isSingleCommand && mainName == null) {
      throw ArgumentError(
        'If command has multiple sub commands, '
        'a main name must be specified!',
      );
    }

    final name = mainName ?? command.name;

    // Create a command runner
    final CommandRunner<void> runner = CommandRunner<void>(
      name,
      description,
    );

    // Single command? Automatically forward to main command
    if (!args.contains(command.name)) {
      args = [command.name, ...args];
    }

    runner.addCommand(command);

    // Single command and no arguments given?

    if ((args.length == 1 || args.contains('--help') || args.contains('-h'))) {
      final usage = command.usage.replaceAll(
        'Usage: $name $name',
        'Usage: $name',
      );
      log(usage);
      return;
    }

    try {
      // Run the command
      await runner.run(args);
    }

    // Print errors in red
    catch (e) {
      var msg = e.toString().replaceAll('Exception: ', '');

      // Single command? Modify help not to require command name

      msg = msg.replaceAll(
        'Usage: $name $name [arguments]',
        'Usage: $name [arguments]',
      );

      log(Colorize(msg).red().toString());
    }
  }

  // ...........................................................................
  /// The command to run
  final Command<dynamic> command;

  /// The main name of the command, used when there is only one sub command.
  final String? mainName;

  /// The description of the command
  final String description;

  /// The logger
  final void Function(String msg) log;
}
