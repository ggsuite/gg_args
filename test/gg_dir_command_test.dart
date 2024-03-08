// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_args/gg_args.dart';
import 'package:path/path.dart';

import 'package:test/test.dart';

void main() {
  final messages = <String>[];
  late CommandRunner<void> runner;
  late GgDirCommandExample ggDirCommand;
  late Directory d;

  Directory initTestDir() {
    final tmp = Directory.systemTemp.createTempSync('gg_test');
    d = Directory('${tmp.path}/test');
    if (d.existsSync()) {
      d.deleteSync(recursive: true);
    }
    d.createSync();
    return d;
  }

  // ...........................................................................
  void initCommand() {
    d = initTestDir();

    ggDirCommand = GgDirCommandExample(
      log: (msg) {
        messages.add(msg);
      },
    );
    runner.addCommand(ggDirCommand);
  }

  // ...........................................................................
  setUp(() {
    runner = CommandRunner<void>('test', 'test');
    messages.clear();
  });

  group('GgDirCommandExample', () {
    // #########################################################################
    group('run(), isCommited()', () {
      group('should throw', () {
        // .....................................................................
        for (final argName in ['-i', '--input']) {
          group('with $argName xyz', () {
            test('should log if directory does not exist', () async {
              initCommand();
              await expectLater(
                runner.run(['example', argName, 'xyz']),
                throwsA(
                  isA<ArgumentError>().having(
                    (e) => e.message,
                    'message',
                    'Directory "xyz" does not exist.',
                  ),
                ),
              );
            });
          });
        }
      });
    });

    // #########################################################################
    test('should succeed', () async {
      initTestDir();
      initCommand();
      await runner.run(['example', '--input', d.path]);
      expect(
        messages,
        ['Example executed for "test".'],
        reason: messages.join('\n'),
      );
      expect(ggDirCommand.inputDirRelative.path, d.path);
      final absoluteDir = Directory(canonicalize(d.path));
      expect(ggDirCommand.inputDir.path, absoluteDir.path);
    });
  });
}
