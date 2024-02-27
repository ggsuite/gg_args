// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'dart:async';

import 'package:args/command_runner.dart';

// #############################################################################
class SubCommand extends Command<dynamic> {
  SubCommand({
    required this.name,
    required this.log,
  }) {
    _addArgs();
  }

  @override
  final String name;

  void Function(String message) log;

  @override
  String get description => 'description of $name';

  @override
  Future<void> run() async {
    final param = argResults?['param'] as String;

    log('Running "$name" with param "$param"');
  }

  // ...........................................................................
  void _addArgs() {
    argParser.addOption(
      'param',
      abbr: 'p',
      help: 'The param to work with',
      valueHelp: 'param',
      mandatory: true,
    );
  }
}

// #############################################################################
/// The command line interface for GgAbc
class CommandWithSubCommands extends Command<dynamic> {
  /// Constructor
  CommandWithSubCommands({required this.log}) {
    addSubcommand(SubCommand(name: 'sub1', log: log));
    addSubcommand(SubCommand(name: 'sub2', log: log));
  }

  /// The log function
  final void Function(String message) log;

  // ...........................................................................
  @override
  final name = 'ggCmd';
  @override
  final description = 'Description';
}
