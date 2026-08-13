// @license
// Copyright (c) ggsuite
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

// ...........................................................................
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_capture_print/gg_capture_print.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';

/// Returns a list of missing sub commands in directory
Future<(List<String> commandList, String? errorMessage)> missingSubCommands({
  required Directory directory,
  required Command<dynamic> command,
  List<String> additionalSubCommands = const [],
}) async {
  // Iterate all files in lib/src/commands
  // and check if they are added to the command runner
  // and if they are added to the help message
  final subCommands =
      directory
          .listSync(recursive: false)
          .where((file) => file.path.endsWith('.dart'))
          .map(
            (e) =>
                basename(e.path)
                    .replaceAll('.dart', '')
                    .replaceAll('_', '-')
                    .replaceAll('gg-', ''),
          )
          .toList()
        ..addAll(additionalSubCommands);

  final runner = CommandRunner<void>('runner', '');
  runner.addCommand(command);

  final messages = <String>[];

  await capturePrint(
    ggLog: messages.add,
    code: () => runner.run([command.name, '--help']),
  );

  final commandList = subCommands
      .where((subCommand) => !hasLog(messages, subCommand))
      .toList();

  final errorMessage = commandList.isNotEmpty
      ? 'The following sub commands needed to be added to '
            'class ${command.name.pascalCase}:\n'
            '- ${commandList.join(', ')}'
      : null;

  return (commandList, errorMessage);
}
