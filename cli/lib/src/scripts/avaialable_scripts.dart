import 'package:io/ansi.dart';

String avaialableScripts(Map<String, dynamic> scripts, {int level = 0}) {
  StringBuffer buffer = StringBuffer();

  scripts.forEach((k, v) {
    buffer.writeln(
        '${'  ' * level}${styleItalic.wrap(k)}: \n${v is Map<String, dynamic> ? avaialableScripts(v, level: level + 1) : ('  ' * (level + 1)) + v}');
  });

  return buffer.toString();
}
