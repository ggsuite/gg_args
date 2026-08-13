// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';
import 'package:gg_console_colors/gg_console_colors.dart';
import 'package:gg_log/gg_log.dart';
import 'package:gg_process/gg_process.dart';

import 'unknown_sub_command_runner.dart';

/// A command runner that automatically forwards to a single sub command.
class GgCommandRunner {
  /// Constructor
  GgCommandRunner({required this.command, required this.ggLog});

  // ...........................................................................
  /// Run the command
  Future<void> run({required List<String> args}) async {
    // Create a command runner
    final CommandRunner<void> runner = UnknownSubCommandRunner(
      '',
      command.description,
    );

    // If no subcommands are defined, add the main command
    runner.addCommand(command);

    // Forward to the main command.
    // Only the first non-flag argument may be the command name itself.
    // Later arguments equal to the name are values, e.g. "do add gg".
    final firstNonFlag = args.indexWhere((a) => !a.startsWith('-'));
    if (firstNonFlag < 0 || args[firstNonFlag] != command.name) {
      args = [command.name, ...args];
    }

    try {
      // Run the command
      await runner.run(args);
    }
    // Print errors in red
    catch (e) {
      var msg = e.toString().replaceAll('Exception: ', '');
      msg = _colorizeMissingParam(msg);
      msg = _colorizeMissingArgument(msg);
      ggLog(msg);
      ggExitCode = 1;
    }
  }

  // ...........................................................................
  String _colorizeMissingParam(String msg) {
    // Capture param as well text before and after
    final regExp = RegExp(
      r'(Invalid argument\(s\): Option )(\w+)( is mandatory.)',
    );
    final match = regExp.firstMatch(msg);

    // Does not match?
    if (match == null || match.groupCount != 3) {
      return msg;
    }

    // Match text before param
    final before = match.group(1)!;
    final param = match.group(2)!;
    final after = match.group(3);

    // Colorize parts
    final beforeYellow = yellow(before);
    final paramRed = red(param);
    final afterYellow = yellow(after!);

    return '$beforeYellow$paramRed$afterYellow\n';
  }

  // ...........................................................................
  String _colorizeMissingArgument(String msg) {
    msg = msg.replaceAll('"', '');

    // Capture param as well text before and after
    final regExp = RegExp(
      r'(Missing )(argument)( for\s*)(--\w+)(\.)',
      multiLine: true,
    );
    final match = regExp.firstMatch(msg);

    // Does not match?
    if (match == null || match.groupCount != 5) {
      return msg;
    }

    // Match text before param
    final missing = match.group(1)!;
    final argument = match.group(2)!;
    final forText = match.group(3)!;
    final param = match.group(4)!;
    final dot = match.group(5)!;

    // Colorize parts
    final missingYellow = yellow(missing);
    final argumentRed = red(argument);
    final forTextYellow = yellow(forText);
    final paramRed = red(param);
    final dotYellow = yellow(dot);

    return '$missingYellow$argumentRed$forTextYellow$paramRed$dotYellow\n';
  }

  // ...........................................................................
  /// The command to run
  final Command<dynamic> command;

  /// The logger
  final GgLog ggLog;
}
