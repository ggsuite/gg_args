// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:convert';
import 'dart:io';

import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:gg_console_colors/gg_console_colors.dart';
import 'package:test/test.dart';

import '../bin/gg_with_no_subcommands.dart';

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
          './bin/gg_with_no_subcommands.dart',
          [],
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
            './bin/gg_with_no_subcommands.dart',
            ['--help'],
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

  group('with sub-no-commands', () {
    group('main()', () {
      // #######################################################################

      test('should print help', () async {
        // Execute bin/gg_cmd.dart and check if it prints help
        final result = await Process.run(
          './bin/gg_with_no_subcommands.dart',
          [],
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
            './bin/gg_with_no_subcommands.dart',
            ['--help'],
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
