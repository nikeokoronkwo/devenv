import 'package:devenv/src/cli/base.dart';
import 'package:devenv/src/cli/run.dart';

Future<void> run(List<String> args) async {
  var runner = await DevenvCommandRunner(
      'devenv', "A tool for making development easier across projects")
    ..addCommand(RunCommand())
    ..run(args);
}
