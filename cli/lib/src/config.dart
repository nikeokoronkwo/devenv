import 'package:json_annotation/json_annotation.dart';
import 'package:devenv/src/utils/extensions.dart';

part 'config.g.dart';

typedef DevenvScripts = Map<String, dynamic>;

extension IndexScripts on DevenvScripts {
  // TODO: Consider edge cases, like names with dots
  /// Get the script with a given [key] from a [DevenvScripts] object
  ///
  /// Returns a list of values containing the commands from the [DevenvScripts] object
  List<String> getScript(String key) {
    final keyparts = key.split('.');
    return _getScriptFromMap(this, keyparts);
  }

  List<String> _getScriptFromMap(
      Map<String, dynamic> scripts, Iterable<String> keys) {
    if (!keys.isSingle) {
      return _getScriptFromMap(scripts[keys.first], keys.skip(1));
    } else {
      final scriptValue = scripts[keys.first];
      if (scriptValue is String)
        return [scriptValue];
      else if (scriptValue is Map<String, dynamic>)
        return _getMapValuesRecursive(scriptValue);
      else
        throw Exception(
            "Cannot have a list value for scripts. Value must either be a map or string");
    }
  }

  List<String> _getMapValuesRecursive(Map<String, dynamic> map) {
    return map.values.map((v) {
      if (v is String)
        return [v];
      else if (v is Map<String, dynamic>)
        return _getMapValuesRecursive(v);
      else
        return v as List<String>;
    }).reduce((value, element) => value + element);
  }
}

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
