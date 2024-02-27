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
      log(msg);
    }
  }

  // ...........................................................................
  String _colorizeMissingParam(String msg) {
    // Capture param as well text before and after
    final regExp =
        RegExp(r'(Invalid argument\(s\): Option )(\w+)( is mandatory.)');
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
        RegExp(r'(Missing )(argument)( for\s*)(\w+)(\.)', multiLine: true);
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
    final missingYellow = Colorize(missing).yellow().toString();
    final argumentRed = Colorize(argument).red().toString();
    final forTextYellow = Colorize(forText).yellow().toString();
    final paramRed = Colorize(param).red().toString();
    final dotYellow = Colorize(dot).yellow().toString();

    return '$missingYellow$argumentRed$forTextYellow$paramRed$dotYellow\n';
  }

  // ...........................................................................
  /// The command to run
  final Command<dynamic> command;

  /// The logger
  final void Function(String msg) log;
}
