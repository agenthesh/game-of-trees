// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LevelStateImpl _$$LevelStateImplFromJson(Map<String, dynamic> json) =>
    _$LevelStateImpl(
      levelData: (json['levelData'] as List<dynamic>?)
              ?.map((e) => CVLevels.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentNumberOfNodes:
          (json['currentNumberOfNodes'] as num?)?.toInt() ?? 4,
      currentLevel: json['currentLevel'] == null
          ? null
          : CVAnswer.fromJson(json['currentLevel'] as Map<String, dynamic>),
      nextLevel: json['nextLevel'] == null
          ? null
          : CVAnswer.fromJson(json['nextLevel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LevelStateImplToJson(_$LevelStateImpl instance) =>
    <String, dynamic>{
      'levelData': instance.levelData,
      'currentNumberOfNodes': instance.currentNumberOfNodes,
      'currentLevel': instance.currentLevel,
      'nextLevel': instance.nextLevel,
    };
