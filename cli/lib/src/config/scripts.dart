import 'package:devenv/src/utils/extensions.dart';

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
