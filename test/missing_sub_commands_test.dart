// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_args/gg_args.dart';
import 'package:test/test.dart';

// .............................................................................
class SubCommand extends Command<void> {
  @override
  String get name => 'sub-command';

  @override
  String get description => 'Sub command description';
}

// .............................................................................
class MyCommand extends Command<void> {
  MyCommand() {
    addSubcommand(SubCommand());
  }

  @override
  String get name => 'my-command';

  @override
  String get description => 'My command description';
}

// .............................................................................
void main() {
  late Directory tmpDir;

  // ...........................................................................
  setUp(() {
    tmpDir = Directory.systemTemp.createTempSync('gg_args_test');
  });

  // ...........................................................................
  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  // ...........................................................................
  group('MissingSubCommands', () {
    group('should return', () {
      group('an empty list and no error message', () {
        test('when all sub commands are added', () async {
          // Create a dart file "sub_command.dart"
          final subCommandDartFile = File('${tmpDir.path}/sub_command.dart');
          subCommandDartFile.writeAsStringSync('// content');

          // Estimate the list of missing sub commands
          final (commandList, errorMessage) = await missingSubCommands(
            directory: tmpDir,
            command: MyCommand(),
          );

          // The list should be empty because MyCommand has all sub commands
          // found in tmpDir
          expect(errorMessage, isNull);
          expect(commandList, isEmpty);
        });
      });

      group('a list of missing sub commands and an error message', () {
        group('when sub commands are missing', () {
          test('including missing additional arguments', () async {
            // Create a dart file "another_sub_command.dart"
            final subCommandDartFile = File(
              '${tmpDir.path}/another_sub_command.dart',
            );
            subCommandDartFile.writeAsStringSync('// content');

            // Estimate the list of missing sub commands
            final (commandList, errorMessage) = await missingSubCommands(
              directory: tmpDir,
              command: MyCommand(),
              additionalSubCommands: ['xyz'],
            );

            // The list should contain "another-sub-command"
            // because MyCommand does not have the sub command "sub-command"
            expect(commandList, ['another-sub-command', 'xyz']);
            expect(
              errorMessage,
              'The following sub commands needed to be added to '
              'class MyCommand:\n- another-sub-command, xyz',
            );
          });
        });
      });
    });
  });
}
