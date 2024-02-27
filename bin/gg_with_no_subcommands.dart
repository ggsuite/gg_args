#!/usr/bin/env dart
// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_args/gg_args.dart';
import '../test/fixtures/command_with_no_sub_commands.dart';

// .............................................................................
Future<void> runWithoutSubCommands({
  required List<String> args,
  required void Function(String msg) log,
}) async {
  final runner = GgCommandRunner(
    command: CommandWithNoSubCommands(log: log),
    log: log,
  );

  await runner.run(args: args);
}

// .............................................................................
Future<void> main(List<String> args) async {
  await runWithoutSubCommands(args: args, log: print);
}
