import 'package:devenv/src/config/scripts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

/// A base devenv configuration that is used
sealed class DevenvConfig {
  /// The script commands, used for running actions on a devenv package
  final DevenvScripts scripts;

  DevenvConfig({this.scripts = const {}});
}

/// A configuration class for the configuration used in a devenv package
///
/// By default, all packages
@JsonSerializable()
class DevenvPkgConfig extends DevenvConfig {
  DevenvPkgConfig({super.scripts});

  factory DevenvPkgConfig.fromJson(Map<String, dynamic> json) =>
      _$DevenvPkgConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DevenvPkgConfigToJson(this);
}

/// A configuration class for the main configuration used in a devenv monorepo
@JsonSerializable()
class DevenvWorkspaceConfig extends DevenvConfig {
  /// Whether the given config is a workspace
  final bool workspace;

  /// the packages included in this workspace
  final List<String> packages;

  DevenvWorkspaceConfig(
      {super.scripts, this.workspace = true, this.packages = const []});

  factory DevenvWorkspaceConfig.fromJson(Map<String, dynamic> json) =>
      _$DevenvWorkspaceConfigFromJson(json);

  Map<String, dynamic> toJson() => _$DevenvWorkspaceConfigToJson(this);
}
