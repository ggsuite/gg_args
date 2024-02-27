// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:convert';
import 'dart:io';

import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:test/test.dart';

import '../bin/gg_with_no_subcommands.dart';
import '../bin/gg_with_subcommands.dart';
import 'fixtures/command_with_sub_commands.dart';
import 'fixtures/command_with_no_sub_commands.dart';

void main() {
  final messages = <String>[];
  setUp(() {
    messages.clear();
  });

  group('Without sub-commands', () {
    final cmd = CommandWithNoSubCommands(log: messages.add);

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
        expect(stdout, contains('Usage: ggCmd [arguments]'));
        expect(stdout, contains(cmd.description));
      });

      // #######################################################################
      group('--help', () {
        test('should print help', () async {
          // Execute bin/gg_with_no_subcommands.dart and check if it prints help
          final result = await Process.run(
            './bin/gg_with_no_subcommands.dart',
            ['--help'],
            stdoutEncoding: utf8,
            stderrEncoding: utf8,
          );

          final stdout = result.stdout as String;
          expect(
            stdout,
            contains('Usage: ggCmd [arguments]'),
          );
        });
      });

      group('runWithoutSubCommands(args)', () {
        // #####################################################################
        group('with args = []', () {
          test('should print help', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await runWithoutSubCommands(
              args: [],
              log: (x) => messages.add(x),
            );

            expect(hasLog('Usage: ggCmd [arguments]', messages), true);
            expect(hasLog('-p, --param=<param>', messages), true);
            expect(hasLog('The param to work with', messages), true);
          });
        });

        // #####################################################################
        group('with args = [ggCmd]', () {
          test('should print help', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await runWithoutSubCommands(
              args: ['ggCmd'],
              log: (x) => messages.add(x),
            );

            expect(hasLog('Usage: ggCmd [arguments]', messages), true);
            expect(hasLog('-p, --param=<param>', messages), true);
            expect(hasLog('The param to work with', messages), true);
          });
        });

        // #####################################################################
        group('with args = [--param]', () {
          test('should print help', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await runWithoutSubCommands(
              args: ['--param', '5'],
              log: (x) => messages.add(x),
            );

            expect(hasLog('Running "ggCmd" with param: "5"', messages), true);
          });
        });

        // #####################################################################
        group('with args = [ggCmd --param]', () {
          test('should print help', () async {
            // Execute bin/gg_with_no_subcommands.dart and check if it prints help
            final messages = <String>[];
            await runWithoutSubCommands(
              args: ['ggCmd', '--param', '5'],
              log: (x) => messages.add(x),
            );

            expect(hasLog('Running "ggCmd" with param: "5"', messages), true);
          });
        });
      });
    });
  });

  // ######################
  // With sub-commands
  // ######################

  group('with sub-commands', () {
    final cmd = CommandWithSubCommands(log: messages.add);

    group('main()', () {
      // #######################################################################

      test('should print help', () async {
        // Execute bin/gg_cmd.dart and check if it prints help
        final result = await Process.run(
          './bin/gg_with_subcommands.dart',
          [],
          stdoutEncoding: utf8,
          stderrEncoding: utf8,
        );

        final stdout = result.stdout as String;
        expect(stdout, contains('Usage: ggCmd [arguments]'));
        expect(stdout, contains(cmd.description));
      });

      // #######################################################################
      group('--help', () {
        test('should print help', () async {
          // Execute bin/gg_with_subcommands.dart and check if it prints help
          final result = await Process.run(
            './bin/gg_with_subcommands.dart',
            ['--help'],
            stdoutEncoding: utf8,
            stderrEncoding: utf8,
          );

          final stdout = result.stdout as String;
          expect(
            stdout,
            contains('Usage: ggCmd [arguments]'),
          );
        });
      });

      // ######################
      // run(args)
      // ######################

      group('run(args)', () {
        // #####################################################################
        group('with args = []', () {
          test('should print help', () async {
            // Execute bin/gg_with_subcommands.dart and check if it prints help

            final messages = <String>[];

            await capturePrint(
              log: (x) => messages.add(x),
              code: () async {
                await runWithSubCommands(
                  args: [],
                  log: (x) => messages.add(x),
                );
              },
            );

            final expectedLogs = [
              'Usage: ggCmd <subcommand> [arguments]',
              'Available subcommands:',
              'sub1   description of sub1',
              'sub2   description of sub2',
            ];

            for (final expectedLog in expectedLogs) {
              expect(hasLog(expectedLog, messages), true);
            }
          });

          // #####################################################################

          group('with args = [--help]', () {
            test('should print help', () async {
              // Execute bin/gg_with_subcommands.dart and check if it prints help

              final messages = <String>[];

              await capturePrint(
                log: (x) => messages.add(x),
                code: () async {
                  await runWithSubCommands(
                    args: ['--help'],
                    log: (x) => messages.add(x),
                  );
                },
              );

              final expectedLogs = [
                'Usage: ggCmd <subcommand> [arguments]',
                'Available subcommands:',
                'sub1   description of sub1',
                'sub2   description of sub2',
              ];

              for (final expectedLog in expectedLogs) {
                expect(hasLog(expectedLog, messages), true);
              }
            });
          });
        });

        // #####################################################################
        group('with args = [sub1]', () {
          test('should print help', () async {
            // Execute bin/gg_with_subcommands.dart and check if it prints help
            final messages = <String>[];

            await capturePrint(
              log: (x) => messages.add(x),
              code: () async {
                await runWithSubCommands(
                  args: ['sub1'],
                  log: messages.add,
                );
              },
            );

            expect(hasLog('Usage: ggCmd [arguments]', messages), true);
          });
        });

        // #####################################################################
        group('with args = [sub1, --help]', () {
          test('should print help', () async {
            // Execute bin/gg_with_subcommands.dart and check if it prints help
            final messages = <String>[];
            await capturePrint(
              log: (x) => messages.add(x),
              code: () async {
                await runWithSubCommands(
                  args: ['sub1', '--help'],
                  log: messages.add,
                );
              },
            );

            expect(hasLog('Usage: ggCmd [arguments]', messages), true);
          });
        });

        // #####################################################################
        group('with args = [--param]', () {
          test('should print help', () async {
            // Execute bin/gg_with_subcommands.dart and check if it prints help
            final messages = <String>[];
            await runWithSubCommands(
              args: ['--param', '5'],
              log: (x) => messages.add(x),
            );

            expect(hasLog('Running "ggCmd" with param: "5"', messages), true);
          });
        });

        // #####################################################################
        group('with args = [ggCmd --param]', () {
          test('should print help', () async {
            // Execute bin/gg_with_subcommands.dart and check if it prints help
            final messages = <String>[];
            await runWithSubCommands(
              args: ['ggCmd', '--param', '5'],
              log: (x) => messages.add(x),
            );

            expect(hasLog('Running "ggCmd" with param: "5"', messages), true);
          });
        });
      });
    });
  });
}
