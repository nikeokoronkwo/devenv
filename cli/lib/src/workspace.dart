import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:devenv/src/config.dart';

import 'package:devenv/src/config/utils.dart';

/// A class for a devenv workspace
class DevenvWorkspace {
  /// The root configuration file for the given workspace
  DevenvConfig get rootConfig => rootPackage.rootConfig;

  /// The root package for the given workspace
  DevenvPackage rootPackage;

  /// Other configurations for packages in a monorepo workspace, with the index being their name
  Map<String, DevenvPackage> packages;

  /// The path to the workspace
  final String path;

  /// A workspace containing a single package
  DevenvWorkspace.single({required this.path, required this.rootPackage})
      : packages = {};

  /// A generic Devenv workspace
  DevenvWorkspace(
      {required this.path,
      required this.rootPackage,
      this.packages = const {}});
}

enum ConfigType { yaml, json }

class DevenvPackage<U extends DevenvConfig> {
  final U rootConfig;
  final String name;
  final String path;
  final ConfigType configType;

  DevenvPackage(
      {required this.rootConfig,
      required this.name,
      required this.path,
      this.configType = ConfigType.json});
}

class DevenvWorkspacePackage extends DevenvPackage<DevenvWorkspaceConfig> {
  DevenvWorkspacePackage(
      {required super.rootConfig,
      required super.name,
      required super.path,
      super.configType});
}

DevenvWorkspace? getWorkspace(String dir) {
  var directory = Directory(dir);
  final devenvConfigFiles = directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((entity) => p.basenameWithoutExtension(entity.path) == 'devenv');
  if (devenvConfigFiles.isEmpty)
    throw Exception("Could not find devenv config at directory $dir");

  // find root devenv config
  final rootDevenvConfigFiles = devenvConfigFiles
      .where((f) => f.parent.absolute.path == directory.absolute.path);
  final rootDevenvConfigFile = rootDevenvConfigFiles.first;

  final rootConfigType = getConfigurationType(rootDevenvConfigFile.path);

  final rootConfig = readConfig(rootDevenvConfigFile, type: rootConfigType);

  if (rootConfig is DevenvWorkspaceConfig) {
    // workspace

    // read root config workspace file
    final rootPkg = DevenvWorkspacePackage(
        rootConfig: rootConfig,
        name: p.basenameWithoutExtension(rootDevenvConfigFile.path),
        path: rootDevenvConfigFile.parent.path,
        configType: rootConfigType);
  } else {
    // read root config file
    final rootPkg = DevenvPackage(
        rootConfig: rootConfig,
        name: p.basenameWithoutExtension(rootDevenvConfigFile.path),
        path: rootDevenvConfigFile.parent.path,
        configType: rootConfigType);

    // create workspace
    return DevenvWorkspace.single(
        path: rootDevenvConfigFile.parent.path, rootPackage: rootPkg);
  }
  return null;
}
