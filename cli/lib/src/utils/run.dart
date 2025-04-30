import 'dart:io';

import 'package:devenv/src/utils/is_glob_pattern.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:io/io.dart';

class Runner {
  ProcessManager manager = ProcessManager();

  Future<int> run(String executable, List<String> args,
      {bool forwardIO = true, String? dir}) async {
    var spawn = await (forwardIO
        ? manager.spawn(executable, expandArgs(args, dir: dir),
            workingDirectory: dir, runInShell: true)
        : manager.spawnDetached(executable, expandArgs(args, dir: dir),
            workingDirectory: dir, runInShell: true));

    return await spawn.exitCode;
  }
}

List<String> expandArgs(List<String> args, {String? dir}) {
  List<String> outputArgs = [];
  for (final arg in args) {
    if (isGlobPattern(arg)) {
      final files = Glob(arg).listSync(root: dir).whereType<File>();
      if (files.isEmpty) continue;

      outputArgs.addAll(files.map((f) => f.path));
    } else
      outputArgs.add(arg);
  }
  return outputArgs;
}
