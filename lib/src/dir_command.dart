// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_log/gg_log.dart';
import 'package:path/path.dart';

// #############################################################################
/// Base class for all ggGit commands
abstract class DirCommand<T> extends Command<T> {
  /// Constructor
  DirCommand({
    required this.ggLog,
    required this.name,
    required this.description,
  }) {
    _addArgs();
  }

  // .........................................................................
  /// The log function
  final GgLog ggLog;

  // ...........................................................................
  /// The name of the command
  @override
  final String name;

  // The description of the command
  @override
  final String description;

  // ...........................................................................
  /// See [DirCommandExample] how to override this method
  @override
  Future<T> run({Directory? directory, GgLog? ggLog});

  // .........................................................................
  /// Returns true if the directory exists
  Future<void> check({required Directory directory}) async {
    // Does directory exist?
    final dirName = basename(canonicalize(directory.path));

    final dir = Directory(directory.path);
    if (!(await dir.exists())) {
      throw ArgumentError('Directory "$dirName" does not exist.');
    }
  }

  // ...........................................................................
  /// Returns [directory] or if null the directory from the arguments
  Directory dir([Directory? directory]) =>
      directory ?? Directory(argResults!['input'] as String);

  /// the input directory as absolute path
  Directory absolute(Directory dir) => Directory(canonicalize(dir.path));

  /// The name of the directory to be checked
  String dirName(Directory dir) => basename(canonicalize(dir.path));

  // ...........................................................................
  void _addArgs() {
    argParser.addOption(
      'input',
      abbr: 'i',
      help: 'The input directory to be processed.',
      defaultsTo: '.',
    );
  }
}

// #############################################################################
/// Example git command implementation
class DirCommandExample extends DirCommand<void> {
  /// Constructor
  DirCommandExample({
    required super.ggLog,
  }) : super(
          name: 'example',
          description: 'This is an example directory command.',
        );

  // ...........................................................................
  @override
  Future<void> run({Directory? directory, GgLog? ggLog}) async {
    ggLog ??= this.ggLog;
    final inputDir = dir(directory);
    await check(directory: inputDir);
    ggLog.call('Example executed for "${dirName(inputDir)}".');
  }
}
