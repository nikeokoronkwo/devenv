import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:devenv/src/utils/log.dart';
import 'package:devenv/src/utils/run.dart';

abstract class DevenvCommand<U> extends Command<U> {
  /// Whether the given command is verbose or not
  bool get verbose => (runner as DevenvCommandRunner).verbose;

  /// A generic logger for logging to stdout
  Logger get logger => verbose ? Logger.verbose() : Logger();

  /// A generic command runner for running commands
  Runner get cmdRunner => Runner();
}

/// Special Implementation of the [CommandRunner] class for the Devenv CLI to provide global flags
///
/// Implements other functionality such as the version
class DevenvCommandRunner extends CommandRunner {
  /// The pheasant version
  final String version;

  /// Whether verbose or not
  bool verbose = false;

  DevenvCommandRunner(super.executableName, super.description,
      {this.version = "0.1.0"})
      : super() {
    argParser
      ..addFlag('version',
          abbr: 'v',
          negatable: false,
          help: "Print out the current devenv version")
      ..addFlag('verbose',
          abbr: 'V', negatable: false, help: "Output Verbose Logging");
    // ..addFlag('define', abbr: 'D', help: 'Define overrides to given config options');
  }

  @override
  Future run(Iterable<String> args) {
    if (args.contains('--version') || args.contains('-v')) {
      return Future.sync(() => print('devenv version $version'));
    }
    if (args.contains('--verbose') || args.contains('-V')) {
      verbose = true;
    }
    return super.run(args);
  }
}
