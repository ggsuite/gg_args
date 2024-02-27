#!/usr/bin/env dart
// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';
import 'package:colorize/colorize.dart';
import 'package:gg_args/gg_args.dart';

// .............................................................................
Future<void> runGgArgs({
  required List<String> args,
  required void Function(String msg) log,
}) async {
  try {
    // Create a command runner
    final CommandRunner<void> runner = CommandRunner<void>(
      'GgArgs',
      'Additions and helpers to the args packages needed by various of our projects. ',
    )..addCommand(GgArgsCmd(log: log));

    // Run the command
    await runner.run(args);
  }

  // Print errors in red
  catch (e) {
    final msg = e.toString().replaceAll('Exception: ', '');
    log(Colorize(msg).red().toString());
    log('Error: $e');
  }
}

// .............................................................................
Future<void> main(List<String> args) async {
  await runGgArgs(
    args: args,
    log: (msg) => print(msg),
  );
}
