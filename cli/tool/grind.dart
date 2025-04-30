import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:grinder/grinder.dart';

void main(List<String> args) {
  pkg.name.value = "devenv-bot";
  pkg.humanName.value = "Devenv";

  pkg.addAllTasks();
  grind(args);
}

// TODO: Include Grind tasks
