// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

// #############################################################################
/// Base class for all ggGit commands
abstract class GgDirCommand extends Command<void> {
  /// Constructor
  GgDirCommand({
    required this.log,
  }) {
    _addArgs();
  }

  /// The log function
  final void Function(String message) log;

  // ...........................................................................
  @mustCallSuper
  @override
  Future<void> run() async {
    inputDir = argResults!['input'] as String;
    inputDirName = basename(canonicalize(inputDir));
  }

  // ...........................................................................
  /// Returns true if the directory exists
  static Future<void> checkDir({required String directory}) async {
    // Does directory exist?
    final dirName = basename(canonicalize(directory));

    final dir = Directory(directory);
    if (!(await dir.exists())) {
      throw ArgumentError('Directory "$dirName" does not exist.');
    }
  }

  // ...........................................................................
  void _addArgs() {
    argParser.addOption(
      'input',
      abbr: 'i',
      help: 'The input directory to be processed.',
      defaultsTo: '.',
    );
  }

  /// The directory to be checked
  late String inputDir;

  /// The name of the directory to be checked
  late String inputDirName;
}

// #############################################################################
/// Example git command implementation
class GgDirCommandExample extends GgDirCommand {
  /// Constructor
  GgDirCommandExample({
    required super.log,
  });

  // ...........................................................................
  @override
  final name = 'example';
  @override
  final description = 'This is an example directory command.';

  // ...........................................................................
  @override
  Future<void> run() async {
    await super.run();
    await GgDirCommand.checkDir(directory: inputDir);
    super.log('Example executed for "$inputDirName".');
  }
}
