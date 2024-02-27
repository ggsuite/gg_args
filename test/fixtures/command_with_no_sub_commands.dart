// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:args/command_runner.dart';

// #############################################################################
/// The command line interface for GgAbc
class CommandWithNoSubCommands extends Command<dynamic> {
  /// Constructor
  CommandWithNoSubCommands({required this.log}) {
    _addArgs();
  }

  /// The log function
  final void Function(String message) log;

  // ...........................................................................
  @override
  final name = 'ggCmd';
  @override
  final description =
      'My very nice short and minimum sixty characters long description.';

  // ...........................................................................
  @override
  Future<void> run() async {
    var param = argResults?['param'] as String;
    log('Running "$name" with param: "$param"');
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
