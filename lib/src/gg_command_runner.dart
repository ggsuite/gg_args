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
    required this.log,
  });

  // ...........................................................................
  /// Run the command
  Future<void> run({
    required List<String> args,
  }) async {
    // Create a command runner
    final CommandRunner<void> runner = CommandRunner<void>(
      '',
      command.description,
    );

    // If no subcommands are defined, add the main command
    runner.addCommand(command);

    // Forward to the main command
    if (!args.contains(command.name)) {
      args = ['ggCmd', ...args];
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
      log(msg);
    }
  }

  // ...........................................................................
  String _colorizeMissingParam(String msg) {
    // Capture param as well text before and after
    final regExp =
        RegExp(r'(Invalid argument\(s\): Option )(param)( is mandatory.)');
    final allMatches = regExp.allMatches(msg);

    // Does not match?
    if (allMatches.isEmpty || allMatches.first.groupCount != 3) {
      return msg;
    }

    // Match text before param
    final before = allMatches.elementAt(0).group(1)!;
    final param = allMatches.elementAt(0).group(2)!;
    final after = allMatches.elementAt(0).group(3);

    // Colorize parts
    final beforeYellow = Colorize(before).yellow().toString();
    final paramRed = Colorize(param).red().toString();
    final afterYellow = Colorize(after!).yellow().toString();

    return '$beforeYellow$paramRed$afterYellow\n';
  }

  // ...........................................................................
  String _colorizeMissingArgument(String msg) {
    msg = msg.replaceAll('"', '');

    // Capture param as well text before and after
    final regExp =
        RegExp(r'(Missing argument for.+)(param)(.*)', multiLine: true);
    final allMatches = regExp.allMatches(msg);

    // Does not match?
    if (allMatches.isEmpty || allMatches.first.groupCount != 3) {
      return msg;
    }

    // Match text before param
    final before = allMatches.elementAt(0).group(1)!;
    final param = allMatches.elementAt(0).group(2)!;
    final after = allMatches.elementAt(0).group(3);

    // Colorize parts
    final beforeYellow = Colorize(before).yellow().toString();
    final paramRed = Colorize(param).red().toString();
    final afterYellow = Colorize(after!).yellow().toString();

    return '$beforeYellow$paramRed$afterYellow\n';
  }

  // ...........................................................................
  /// The command to run
  final Command<dynamic> command;

  /// The logger
  final void Function(String msg) log;
}
