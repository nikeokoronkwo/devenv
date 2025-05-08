import 'dart:convert';
import 'dart:io';

import 'package:devenv/src/config/scripts.dart';
import 'package:devenv/src/scripts/avaialable_scripts.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import 'package:devenv/src/cli/base.dart';
import 'package:devenv/src/config.dart';
import 'package:devenv/src/utils/extensions.dart';
import 'package:devenv/src/workspace.dart';

class RunCommand extends DevenvCommand {
  String name = "run";
  String description = "Run scripts or tasks on a devenv package";

  RunCommand() {
    argParser.addFlag('show-available',
        help: "Show available scripts to run from config",
        negatable: true,
        defaultsTo: true);
    argParser.addFlag('forward-io',
        help: "Forward I/O (stdin and stdout) when running script",
        negatable: true,
        defaultsTo: true);

    // TODO: Directory
    // TODO: Package specify
  }

  @override
  void run() async {
    List<String> args = argResults?.rest ?? [];

    try {
      // get workspace, if avaialable
      final workspace = getWorkspace(p.current);
      if (workspace == null) {
        // error: not in workspace
        logger.severe(
            "Package not found: Please run in a devenv package or workspace");
        exit(ExitCode.usage.code);
      }

      // get scripts
      var workspaceScripts = workspace.rootConfig.scripts;

      if (args.isEmpty && (argResults?['show-available'] ?? false)) {
        if (workspaceScripts.isEmpty) {
          // show no avaialable commands
          logger.stdout('No scripts available');
        } else {
          // show available commands
          logger.stdout(wrapWith('Available Commands', [styleBold])!);
          logger.stdout(avaialableScripts(workspaceScripts));
        }
        return;
      } else if (args.isEmpty) {
        return;
      }

      // find command(s) from workspace
      final selectedScript = workspaceScripts.getScript(args.first);

      // log command name and script
      logger.stdout(wrapWith(args.first + ':  ', [styleBold])! +
          (selectedScript.isSingle
              // TODO: Format multiline scripts
              ? selectedScript.first
              : '\n\t' + selectedScript.join('\n\t')) +
          ' ' +
          args.skip(1).join(' '));

      logger.stdout('');

      // run command
      for (final selScriptPart in selectedScript) {
        // multiline scripts
        final scriptLines = LineSplitter().convert(selScriptPart);

        for (final line in scriptLines) {
          final [a, ...b] = line.split(' ');
          final exitCode = await cmdRunner.run(a, [...b, ...args.skip(1)],
              forwardIO: argResults?['forward-io'], dir: workspace.path);
          if (exitCode != 0) exit(exitCode);
        }
        // pad before next run
        logger.stdout('');
      }

      exit(0);
    } catch (e) {
      rethrow;
    }
  }
}
