// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:convert';
import 'dart:io';

import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:gg_console_colors/gg_console_colors.dart';
import 'package:test/test.dart';

import '../bin/gg_with_no_subcommands.dart';
import '../bin/gg_with_subcommands.dart';

void main() {
  final messages = <String>[];
  setUp(() {
    messages.clear();
  });

  // With sub-commands
  // ######################

  group('with sub-commands', () {
    group('main()', () {
      // #######################################################################

      test('should print help', () async {
        // Execute bin/gg_cmd.dart and check if it prints help
        final result = await Process.run(
          Platform.resolvedExecutable,
          ['run', 'bin/gg_with_no_subcommands.dart'],
          stdoutEncoding: utf8,
          stderrEncoding: utf8,
        );

        final stdout = result.stdout as String;
        final expectedLogs = [
          'Invalid argument(s):',
          red('param'),
          'is mandatory.',
        ];

        for (final expectedLog in expectedLogs) {
          expect(stdout, contains(expectedLog));
        }
      });

      // #######################################################################
      group('--help', () {
        test('should print help', () async {
          // Execute bin/gg_cmd.dart and check if it prints help
          final result = await Process.run(
            Platform.resolvedExecutable,
            ['run', 'bin/gg_with_no_subcommands.dart', '--help'],
            stdoutEncoding: utf8,
            stderrEncoding: utf8,
          );

          final stdout = result.stdout as String;
          final expectedLogs = [
            'Usage:  ggCmd [arguments]',
            'p, --param=<param> (mandatory)    The param to work with',
          ];

          for (final expectedLog in expectedLogs) {
            expect(stdout, contains(expectedLog));
          }
        });
      });

      // ######################
      // run(args)
      // ######################

      group('run(args)', () {
        // #####################################################################
        group('with args = []', () {
          test('should print help', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help

            final messages = <String>[];

            await capturePrint(
              ggLog: messages.add,
              code: () async {
                await runWithoutSubCommands(args: [], ggLog: messages.add);
              },
            );

            final expectedLogs = [
              'Invalid argument(s):',
              red('param'),
              'is mandatory.',
            ];

            for (final expectedLog in expectedLogs) {
              expect(hasLog(messages, expectedLog), true);
            }
          });

          // ###################################################################

          group('with args = [--help]', () {
            test('should print help', () async {
              // Execute bin/gg_with_no_subcommands.dart and check if it prints help

              final messages = <String>[];

              await capturePrint(
                ggLog: messages.add,
                code: () async {
                  await runWithoutSubCommands(
                    args: ['--help'],
                    ggLog: messages.add,
                  );
                },
              );

              final expectedLogs = [
                'Usage:  ggCmd [arguments]',
                'p, --param=<param> (mandatory)    The param to work with',
              ];

              for (final expectedLog in expectedLogs) {
                expect(hasLog(messages, expectedLog), true);
              }
            });
          });
        });

        // #####################################################################
        group('with args = [--param]', () {
          test('should print error and set exitCode to 1', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await capturePrint(
              ggLog: messages.add,
              code: () async {
                await runWithoutSubCommands(
                  args: ['--param'],
                  ggLog: messages.add,
                );
              },
            );

            final expectedLogs = ['Missing', 'argument', 'for', red('--param')];

            for (final expectedLog in expectedLogs) {
              expect(hasLog(messages, expectedLog), true);
            }

            expect(exitCode, 1);
          });
        });

        // #####################################################################
        group('with args = [--param 5]', () {
          test('should print error', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await capturePrint(
              ggLog: messages.add,
              code: () async {
                await runWithoutSubCommands(
                  args: ['--param', '5'],
                  ggLog: messages.add,
                );
              },
            );

            final expectedLogs = ['Running "ggCmd" with param: "5"'];

            for (final expectedLog in expectedLogs) {
              expect(hasLog(messages, expectedLog), true);
            }
          });
        });
      });
    });
  });

  group('with args containing the command name as value', () {
    // #########################################################################
    group('with args = [add, ggCmd]', () {
      test('should forward to the sub command', () async {
        // Regression: an argument value equal to the command name must not
        // prevent forwarding to the main command, e.g. "gg do add gg".
        final messages = <String>[];
        exitCode = 0;

        await capturePrint(
          ggLog: messages.add,
          code: () async {
            await runWithSubCommands(
              args: ['add', 'ggCmd'],
              ggLog: messages.add,
            );
          },
        );

        expect(
          hasLog(messages, 'Cannot specify arguments before a command.'),
          false,
        );
        expect(hasLog(messages, 'Running "add" with targets "ggCmd"'), true);
        expect(exitCode, 0);
      });
    });

    // #########################################################################
    group('with args = [sub1, --param, ggCmd]', () {
      test('should forward to the sub command', () async {
        final messages = <String>[];
        exitCode = 0;

        await capturePrint(
          ggLog: messages.add,
          code: () async {
            await runWithSubCommands(
              args: ['sub1', '--param', 'ggCmd'],
              ggLog: messages.add,
            );
          },
        );

        expect(hasLog(messages, 'Running "sub1" with param "ggCmd"'), true);
        expect(exitCode, 0);
      });
    });

    // #########################################################################
    group('with args = [ggCmd, add, ggCmd]', () {
      test('should not prepend the command name twice', () async {
        final messages = <String>[];
        exitCode = 0;

        await capturePrint(
          ggLog: messages.add,
          code: () async {
            await runWithSubCommands(
              args: ['ggCmd', 'add', 'ggCmd'],
              ggLog: messages.add,
            );
          },
        );

        expect(hasLog(messages, 'Running "add" with targets "ggCmd"'), true);
        expect(exitCode, 0);
      });
    });

    // #########################################################################
    group('with args = [--help]', () {
      test('should still forward to the main command', () async {
        final messages = <String>[];

        await capturePrint(
          ggLog: messages.add,
          code: () async {
            await runWithSubCommands(args: ['--help'], ggLog: messages.add);
          },
        );

        expect(
          hasLog(messages, 'Usage:  ggCmd <subcommand> [arguments]'),
          true,
        );
      });
    });
  });

  group('with sub-no-commands', () {
    group('main()', () {
      // #######################################################################

      test('should print help', () async {
        // Execute bin/gg_cmd.dart and check if it prints help
        final result = await Process.run(
          Platform.resolvedExecutable,
          ['run', 'bin/gg_with_no_subcommands.dart'],
          stdoutEncoding: utf8,
          stderrEncoding: utf8,
        );

        final stdout = result.stdout as String;
        final expectedLogs = [
          'Invalid argument(s):',
          red('param'),
          'is mandatory.',
        ];

        for (final expectedLog in expectedLogs) {
          expect(stdout, contains(expectedLog));
        }
      });

      // #######################################################################
      group('--help', () {
        test('should print help', () async {
          // Execute bin/gg_cmd.dart and check if it prints help
          final result = await Process.run(
            Platform.resolvedExecutable,
            ['run', 'bin/gg_with_no_subcommands.dart', '--help'],
            stdoutEncoding: utf8,
            stderrEncoding: utf8,
          );

          final stdout = result.stdout as String;
          final expectedLogs = [
            'Usage:  ggCmd [arguments]',
            'p, --param=<param> (mandatory)    The param to work with',
          ];

          for (final expectedLog in expectedLogs) {
            expect(stdout, contains(expectedLog));
          }
        });
      });

      // ######################
      // run(args)
      // ######################

      group('run(args)', () {
        // #####################################################################
        group('with args = []', () {
          test('should print help', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help

            final messages = <String>[];

            await capturePrint(
              ggLog: messages.add,
              code: () async {
                await runWithoutSubCommands(args: [], ggLog: messages.add);
              },
            );

            final expectedLogs = [
              'Invalid argument(s):',
              red('param'),
              'is mandatory.',
            ];

            for (final expectedLog in expectedLogs) {
              expect(hasLog(messages, expectedLog), true);
            }
          });

          // ###################################################################

          group('with args = [--help]', () {
            test('should print help', () async {
              // Execute bin/gg_with_no_subcommands.dart and check if it prints help

              final messages = <String>[];

              await capturePrint(
                ggLog: messages.add,
                code: () async {
                  await runWithoutSubCommands(
                    args: ['--help'],
                    ggLog: messages.add,
                  );
                },
              );

              final expectedLogs = [
                'Usage:  ggCmd [arguments]',
                'p, --param=<param> (mandatory)    The param to work with',
              ];

              for (final expectedLog in expectedLogs) {
                expect(hasLog(messages, expectedLog), true);
              }
            });
          });
        });

        // #####################################################################
        group('with args = [--param]', () {
          test('should print error', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await capturePrint(
              ggLog: messages.add,
              code: () async {
                await runWithoutSubCommands(
                  args: ['--param'],
                  ggLog: messages.add,
                );
              },
            );

            final expectedLogs = [
              'Missing',
              red('argument'),
              'for',
              red('--param'),
            ];

            for (final expectedLog in expectedLogs) {
              expect(hasLog(messages, expectedLog), true);
            }
          });
        });

        // #####################################################################
        group('with args = [--param 5]', () {
          test('should print error', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await capturePrint(
              ggLog: messages.add,
              code: () async {
                await runWithoutSubCommands(
                  args: ['--param', '5'],
                  ggLog: messages.add,
                );
              },
            );

            final expectedLogs = ['Running "ggCmd" with param: "5"'];

            for (final expectedLog in expectedLogs) {
              expect(hasLog(messages, expectedLog), true);
            }
          });
        });
      });
    });
  });
}
