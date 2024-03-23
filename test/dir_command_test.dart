// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_args/gg_args.dart';
import 'package:test/test.dart';

void main() {
  final messages = <String>[];
  late CommandRunner<void> runner;
  late DirCommandExample dirCommand;
  late Directory d;

  // ...........................................................................
  Directory initTestDir() {
    final tmp = Directory.systemTemp.createTempSync('gg_test');
    d = Directory('${tmp.path}/test');
    d.createSync();
    return d;
  }

  // ...........................................................................
  void initCommand({Directory? inputDir}) {
    dirCommand = DirCommandExample(
      ggLog: (msg) {
        messages.add(msg);
      },
    );
    runner.addCommand(dirCommand);
  }

  // ...........................................................................
  setUp(() {
    initTestDir();
    runner = CommandRunner<void>('test', 'test');
    messages.clear();
  });

  // ...........................................................................
  tearDown(() {
    d.deleteSync(recursive: true);
  });

  group('DirCommandExample', () {
    // #########################################################################
    group('run()', () {
      group('should throw', () {
        group('when input directory does not exist', () {
          // ...................................................................
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

      group('should log a message', () {
        test('when input directory is given via constructor', () async {
          initCommand(inputDir: d);
          await dirCommand.run(directory: Directory('./test/fixtures'));
          expect(
            messages,
            ['Example executed for "fixtures".'],
            reason: messages.join('\n'),
          );
        });

        test('when input directory is given via --input argument', () async {
          initCommand();
          await runner.run(['example', '--input', d.path]);
          expect(messages.last, 'Example executed for "test".');

          // Run again
          await runner.run(['example', '--input', d.path]);
          expect(messages.last, 'Example executed for "test".');
        });
      });
    });

    // #########################################################################
    test('should succeed', () async {
      initTestDir();
      initCommand();
      await runner.run(['example', '--input', './test']);
      expect(
        messages,
        ['Example executed for "test".'],
        reason: messages.join('\n'),
      );
      expect(
        dirCommand.absolute(dirCommand.dir()).path,
        endsWith('gg_args/test'),
      );
    });
  });
}
