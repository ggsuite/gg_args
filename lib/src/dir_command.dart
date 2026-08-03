// @license
// Copyright (c) ggsuite. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gg_log/gg_log.dart';
import 'package:matcher/expect.dart';
import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart';

// #############################################################################
/// Base class for all ggGit commands
abstract class DirCommand<T> extends Command<dynamic> {
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
  @mustCallSuper
  @override
  Future<T> run() {
    return exec(directory: dirFromArgs, ggLog: ggLog);
  }

  // ...........................................................................
  /// Must be implemented in subclasses
  /// See [DirCommandExample] how to override this method
  Future<T> exec({required Directory directory, required GgLog ggLog}) async {
    final result = await get(directory: directory, ggLog: ggLog);
    final resultString = result.toString();
    if (resultString.isNotEmpty && resultString != 'null') {
      ggLog(result.toString());
    }

    return result;
  }

  // ...........................................................................
  /// Must be implemented in subclasses
  /// See [DirCommandExample] how to override this method
  Future<T> get({required Directory directory, required GgLog ggLog});

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
  /// Returns the directory from the command line arguments
  Directory get dirFromArgs => Directory(argResults!['input'] as String);

  // ...........................................................................
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
class DirCommandExample extends DirCommand<bool> {
  /// Constructor
  DirCommandExample({required super.ggLog})
    : super(
        name: 'example',
        description: 'This is an example directory command.',
      );

  // ...........................................................................
  @override
  Future<bool> get({required Directory directory, required GgLog ggLog}) async {
    await check(directory: directory);
    return true;
  }
}

// #############################################################################
/// Example git command implementation
class VoidDirCommandExample extends DirCommand<void> {
  /// Constructor
  VoidDirCommandExample({required super.ggLog})
    : super(
        name: 'void-example',
        description: 'This is an void example directory command.',
      );

  // ...........................................................................
  @override
  Future<void> get({required Directory directory, required GgLog ggLog}) async {
    await check(directory: directory);
  }
}

// #############################################################################
/// Mock for [DirCommand]
class MockDirCommand<T> extends Mock implements DirCommand<T> {
  // ...........................................................................
  /// Makes [exec] successful or not
  void mockExec({
    required T result,
    GgLog? ggLog,
    Directory? directory,
    bool doThrow = false,
    String? message,
  }) {
    when(
      () => exec(
        directory: any(
          named: 'directory',
          that: predicate<Directory>(
            (d) => directory == null || d.path == directory.path,
          ),
        ),
        ggLog: ggLog ?? any(named: 'ggLog'),
      ),
    ).thenAnswer((invocation) async {
      return defaultReaction(
        doThrow: doThrow,
        invocation: invocation,
        result: result,
        message: message,
      );
    });
  }

  // ...........................................................................
  /// Mocks the result of the get command
  void mockGet({
    required T result,
    bool doThrow = false,
    Directory? directory,
    GgLog? ggLog,
    String? message,
  }) {
    when(
      () => get(
        ggLog: ggLog ?? any(named: 'ggLog'),
        directory: any(
          named: 'directory',
          that: predicate<Directory>(
            (d) => directory == null || d.path == directory.path,
          ),
        ),
      ),
    ).thenAnswer((invocation) async {
      return defaultReaction(
        doThrow: doThrow,
        invocation: invocation,
        result: result,
        message: message,
      );
    });
  }

  // ...........................................................................
  /// Default reaction for [exec] and [get]
  Future<T> defaultReaction({
    required bool doThrow,
    required Invocation invocation,
    required T result,
    String? message,
  }) {
    message ??= runtimeType.toString().replaceAll('Mock', '').split('<').first;

    if (doThrow) {
      throw Exception('✗ $message');
    } else {
      final ggLog = invocation.namedArguments[const Symbol('ggLog')];
      if (ggLog != null) {
        ggLog('✓ $message');
      }
    }
    return Future.value(result);
  }
}
