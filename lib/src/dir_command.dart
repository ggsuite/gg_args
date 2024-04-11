// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
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
  @mustCallSuper
  @override
  Future<T> run() {
    return exec(directory: dirFromArgs, ggLog: ggLog);
  }

  // ...........................................................................
  /// Must be implemented in subclasses
  /// See [DirCommandExample] how to override this method
  Future<T> exec({
    required Directory directory,
    required GgLog ggLog,
  });

  // ...........................................................................
  /// Can be implemented in subclasses
  Future<T?> get({
    required Directory directory,
    required GgLog ggLog,
  }) async {
    return null;
  }

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
  DirCommandExample({
    required super.ggLog,
  }) : super(
          name: 'example',
          description: 'This is an example directory command.',
        );

  // ...........................................................................
  @override
  Future<bool> exec({
    required Directory directory,
    required GgLog ggLog,
  }) async {
    await check(directory: directory);
    ggLog.call('Example executed for "${dirName(directory)}".');
    return true;
  }
}

// #############################################################################
/// Mock for [DirCommand]
class MockDirCommand<T> extends Mock implements DirCommand<T> {
  // ...........................................................................
  /// Makes [exec] successful or not
  void mockExec({
    T? result,
    required GgLog ggLog,
    required Directory directory,
    bool doThrow = false,
  }) {
    final className =
        runtimeType.toString().replaceAll('Mock', '').split('<').first;

    when(
      () => exec(
        directory: any(
          named: 'directory',
          that: predicate<Directory>(
            (d) => d.path == directory.path,
          ),
        ),
        ggLog: any(named: 'ggLog'),
      ),
    ).thenAnswer((invocation) async {
      if (doThrow) {
        throw Exception('❌ $className');
      } else {
        final ggLog = invocation.namedArguments[const Symbol('ggLog')];
        ggLog('✅ $className');
      }
      return Future.value(result);
    });
  }

  // ...........................................................................
  /// Mocks the result of the get command
  void mockGet({
    T? result,
    bool doThrow = false,
    required Directory directory,
    required GgLog ggLog,
    String? message,
  }) {
    final className =
        runtimeType.toString().replaceAll('Mock', '').split('<').first;

    final exceptionMessage = message ?? className;

    when(() => get(ggLog: ggLog, directory: directory)).thenAnswer((_) async {
      if (doThrow) {
        throw Exception('❌ $exceptionMessage');
      } else {
        if (message != null) {
          ggLog(message);
        }
      }
      return Future.value(result);
    });
  }
}
