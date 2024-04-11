// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_args/gg_args.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  final messages = <String>[];
  late CommandRunner<dynamic> runner;
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
    runner = CommandRunner<dynamic>('test', 'test');
    messages.clear();
    registerFallbackValue(d);
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
          await dirCommand.exec(
            directory: Directory('./test/fixtures'),
            ggLog: messages.add,
          );
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
    group('get()', () {
      test('should return null currently', () async {
        initCommand();
        final result = await dirCommand.get(directory: d, ggLog: messages.add);
        expect(result, isNull);
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
        dirCommand.absolute(dirCommand.dirFromArgs).path,
        endsWith('gg_args/test'),
      );
    });
  });

  group('MockDirCommand', () {
    group('mockSuccess', () {
      group('should return »✅ DirCommand!«', () {
        group('when called with', () {
          test('success: true', () async {
            final mock = MockDirCommand<bool>();
            mock.mockExec(
              result: true,
              directory: d,
              ggLog: messages.add,
            );
            await mock.exec(directory: d, ggLog: messages.add);
            expect(messages.first, contains('✅ DirCommand'));
          });
        });
      });

      group('should throw »❌ Did work!', () {
        group('when called with', () {
          test('success: false', () async {
            final mock = MockDirCommand<bool>();
            mock.mockExec(
              directory: d,
              ggLog: messages.add,
              doThrow: true,
            );

            late String exception;
            try {
              await mock.exec(directory: d, ggLog: messages.add);
            } catch (e) {
              exception = e.toString();
            }
            expect(exception, contains('❌ DirCommand'));
          });
        });
      });
    });

    group('mockGet', () {
      test('should make get returning a desired value', () async {
        final dirCommand = MockDirCommand<int>();
        dirCommand.mockGet(
          result: 42,
          directory: d,
          ggLog: messages.add,
          message: 'Log this',
        );
        expect(await dirCommand.get(directory: d, ggLog: messages.add), 42);
        expect(messages, ['Log this']);
      });

      test('should throw when doThrow is true', () async {
        final dirCommand = MockDirCommand<int>();
        dirCommand.mockGet(
          directory: d,
          ggLog: messages.add,
          doThrow: true,
          message: 'Message',
        );

        late String exception;
        try {
          await dirCommand.get(directory: d, ggLog: messages.add);
        } catch (e) {
          exception = e.toString();
        }

        expect(exception, contains('❌ Message'));
      });
    });
  });
}
