// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:test/test.dart';

import '../bin/gg_with_subcommands.dart';

void main() {
  late List<String> messages;

  setUp(() {
    messages = <String>[];
    exitCode = 0;
  });

  tearDown(() {
    exitCode = 0;
  });

  // ...........................................................................
  Future<void> run(List<String> args) async {
    await capturePrint(
      ggLog: messages.add,
      code: () async {
        await runWithSubCommands(args: args, ggLog: messages.add);
      },
    );
  }

  group('UnknownSubCommandRunner', () {
    group('reports unknown sub commands', () {
      // #######################################################################
      test('when no help flag is given', () async {
        await run(['xyz']);

        expect(
          hasLog(messages, 'Could not find a subcommand named xyz for  ggCmd.'),
          true,
        );
        expect(exitCode, 1);
      });

      // #######################################################################
      test('when -h is given', () async {
        await run(['xyz', '-h']);

        expect(
          hasLog(messages, 'Could not find a subcommand named xyz for  ggCmd.'),
          true,
        );
        expect(exitCode, 1);
      });

      // #######################################################################
      test('when --help is given', () async {
        await run(['xyz', '--help']);

        expect(
          hasLog(messages, 'Could not find a subcommand named xyz for  ggCmd.'),
          true,
        );
        expect(exitCode, 1);
      });

      // #######################################################################
      test('when the help flag comes first', () async {
        await run(['-h', 'xyz']);

        expect(
          hasLog(messages, 'Could not find a subcommand named xyz for  ggCmd.'),
          true,
        );
        expect(exitCode, 1);
      });

      // #######################################################################
      test('on a nested branch command with --help', () async {
        await run(['branch', 'xyz', '--help']);

        expect(
          hasLog(
            messages,
            'Could not find a subcommand named xyz for  ggCmd branch.',
          ),
          true,
        );
        expect(exitCode, 1);
      });

      // #######################################################################
      test('on a nested branch command without --help', () async {
        await run(['branch', 'xyz']);

        expect(
          hasLog(
            messages,
            'Could not find a subcommand named xyz for  ggCmd branch.',
          ),
          true,
        );
        expect(exitCode, 1);
      });
    });

    // .........................................................................
    group('does not report anything', () {
      // #######################################################################
      test('when --help is given for the main command', () async {
        await run(['--help']);

        expect(
          hasLog(messages, 'Usage:  ggCmd <subcommand> [arguments]'),
          true,
        );
        expect(exitCode, 0);
      });

      // #######################################################################
      test('when -h is given for a leaf sub command', () async {
        await run(['sub1', '-h']);

        expect(hasLog(messages, 'Usage:  ggCmd sub1 [arguments]'), true);
        expect(exitCode, 0);
      });

      // #######################################################################
      test('when --help is given for a nested leaf sub command', () async {
        await run(['branch', 'leaf', '--help']);

        expect(hasLog(messages, 'Usage:  ggCmd branch leaf [arguments]'), true);
        expect(exitCode, 0);
      });

      // #######################################################################
      test('when --help is given for a nested branch command', () async {
        await run(['branch', '--help']);

        expect(
          hasLog(messages, 'Usage:  ggCmd branch <subcommand> [arguments]'),
          true,
        );
        expect(exitCode, 0);
      });

      // #######################################################################
      test('when an option value looks like a command', () async {
        await run(['sub1', '-p', 'publish']);

        expect(hasLog(messages, 'Running "sub1" with param "publish"'), true);
        expect(exitCode, 0);
      });

      // #######################################################################
      test('when a leaf command takes positional arguments', () async {
        await run(['add', 'ticket', '69']);

        expect(
          hasLog(messages, 'Running "add" with targets "ticket, 69"'),
          true,
        );
        expect(exitCode, 0);
      });

      // #######################################################################
      test('when a nested leaf command takes positional arguments', () async {
        await run(['branch', 'rest', 'ticket', '69']);

        expect(
          hasLog(messages, 'Running "rest" with targets "ticket, 69"'),
          true,
        );
        expect(exitCode, 0);
      });

      // #######################################################################
      test('when no arguments are given', () async {
        await run([]);

        expect(hasLog(messages, 'Missing subcommand for  ggCmd.'), true);
        expect(exitCode, 1);
      });
    });
  });
}
