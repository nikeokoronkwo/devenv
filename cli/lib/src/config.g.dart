// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevenvPkgConfig _$DevenvPkgConfigFromJson(Map<String, dynamic> json) =>
    DevenvPkgConfig(
      scripts: json['scripts'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$DevenvPkgConfigToJson(DevenvPkgConfig instance) =>
    <String, dynamic>{
      'scripts': instance.scripts,
    };

DevenvWorkspaceConfig _$DevenvWorkspaceConfigFromJson(
        Map<String, dynamic> json) =>
    DevenvWorkspaceConfig(
      scripts: json['scripts'] as Map<String, dynamic>? ?? const {},
      workspace: json['workspace'] as bool? ?? true,
      packages: (json['packages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DevenvWorkspaceConfigToJson(
        DevenvWorkspaceConfig instance) =>
    <String, dynamic>{
      'scripts': instance.scripts,
      'workspace': instance.workspace,
      'packages': instance.packages,
    };
