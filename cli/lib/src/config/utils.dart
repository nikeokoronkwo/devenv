import 'dart:convert';
import 'dart:io';
import 'package:devenv/src/config.dart';
import 'package:devenv/src/workspace.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

ConfigType getConfigurationType(String path) {
  final ext = p.extension(path);
  return switch (ext) {
    '.json' => ConfigType.json,
    '.yaml' => ConfigType.yaml,
    _ => throw Exception(
        'Unsupported file type for configuration: $ext, at ${p.dirname(path)}')
  };
}

DevenvConfig readConfig(File file, {ConfigType? type, bool workspace = false}) {
  final ConfigType configType = type ?? getConfigurationType(file.path);
  final fileContents = file.readAsStringSync();

  try {
    final Map<String, dynamic> config = switch (configType) {
      ConfigType.json => json.decode(fileContents),
      // have to do this because of the way [YamlMap] works...
      ConfigType.yaml => json.decode(json.encode(loadYaml(fileContents))),
    };
    if (config.containsKey('workspace') && config['workspace']) {
      return DevenvWorkspaceConfig.fromJson(config);
    } else {
      return DevenvPkgConfig.fromJson(config);
    }
  } catch (e) {
    // TODO: Handle error cases
    rethrow;
  }
}
