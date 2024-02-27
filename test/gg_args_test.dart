// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';
import 'package:gg_args/gg_args.dart';
import 'package:test/test.dart';

void main() {
  final messages = <String>[];

  group('GgArgs()', () {
    // #########################################################################
    group('exec()', () {
      test('description of the test ', () async {
        final ggArgs = GgArgs(param: 'foo', log: (msg) => messages.add(msg));

        await ggArgs.exec();
      });
    });

    // #########################################################################
    group('Command', () {
      test('should allow to run the code from command line', () async {
        final ggArgs = GgArgsCmd(log: (msg) => messages.add(msg));

        final CommandRunner<void> runner = CommandRunner<void>(
          'ggArgs',
          'Description goes here.',
        )..addCommand(ggArgs);

        await runner.run(['ggArgs', '--param', 'foo']);
      });
    });
  });
}
