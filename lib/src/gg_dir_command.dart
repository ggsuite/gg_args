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
  ///
  /// - [log] is the log function
  /// - [inputDir] is the directory to be processed.
  ///   If not given, it will read from --input argument, when calling run().
  GgDirCommand({
    required this.log,
    Directory? inputDir,
  }) {
    if (inputDir != null) {
      _initInputDir(inputDir);
    }

    _addArgs();
  }

  /// The log function
  final void Function(String message) log;

  // ...........................................................................
  @mustCallSuper
  @override
  Future<void> run() async {
    // Input dir not is given via constructor?
    // Take input dir from --input argument.
    if (!_isInitialized) {
      final dirFromArgs = Directory(argResults!['input'] as String);
      _initInputDir(dirFromArgs);
    }

    // Input dir is given via constructor?
    // Complain if input dir is also given via --input argument.
    else {
      if (_isFirstRun && argResults?.options.contains('input') == true) {
        throw ArgumentError(
          'The input directory is specified twice: '
          'One tima via constructor and a second time via --input argument.',
        );
      }
    }

    _isFirstRun = false;
  }

  // ...........................................................................
  /// Returns true if the directory exists
  static Future<void> checkDir({required Directory directory}) async {
    // Does directory exist?
    final dirName = basename(canonicalize(directory.path));

    final dir = Directory(directory.path);
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

  /// The directory to be checked as relative path
  Directory get inputDirRelative => _inputDirRelative;

  /// The directory to be checked as absolute path
  Directory get inputDir => _inputDir;

  /// The name of the directory to be checked
  String get inputDirName => _inputDirName;

  // ...........................................................................
  late Directory _inputDirRelative;
  late Directory _inputDir;
  late String _inputDirName;

  // ...........................................................................
  bool _isInitialized = false;
  bool _isFirstRun = true;

  // ...........................................................................
  void _initInputDir(Directory dir) {
    _inputDirRelative = dir;
    _inputDir = Directory(canonicalize(inputDirRelative.path));
    _inputDirName = basename(canonicalize(inputDirRelative.path));
    _isInitialized = true;
  }
}

// #############################################################################
/// Example git command implementation
class GgDirCommandExample extends GgDirCommand {
  /// Constructor
  GgDirCommandExample({
    required super.log,
    super.inputDir,
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
    await GgDirCommand.checkDir(directory: inputDirRelative);
    super.log('Example executed for "$inputDirName".');
  }
}
