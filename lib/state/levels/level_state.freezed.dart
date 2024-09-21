// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'level_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LevelState _$LevelStateFromJson(Map<String, dynamic> json) {
  return _LevelState.fromJson(json);
}

/// @nodoc
mixin _$LevelState {
  List<CVLevels> get levelData => throw _privateConstructorUsedError;
  int get currentNumberOfNodes => throw _privateConstructorUsedError;
  CVAnswer? get currentLevel => throw _privateConstructorUsedError;
  CVAnswer? get nextLevel => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Rect? get rect => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LevelStateCopyWith<LevelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LevelStateCopyWith<$Res> {
  factory $LevelStateCopyWith(
          LevelState value, $Res Function(LevelState) then) =
      _$LevelStateCopyWithImpl<$Res, LevelState>;
  @useResult
  $Res call(
      {List<CVLevels> levelData,
      int currentNumberOfNodes,
      CVAnswer? currentLevel,
      CVAnswer? nextLevel,
      @JsonKey(includeFromJson: false, includeToJson: false) Rect? rect});
}

/// @nodoc
class _$LevelStateCopyWithImpl<$Res, $Val extends LevelState>
    implements $LevelStateCopyWith<$Res> {
  _$LevelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? levelData = null,
    Object? currentNumberOfNodes = null,
    Object? currentLevel = freezed,
    Object? nextLevel = freezed,
    Object? rect = freezed,
  }) {
    return _then(_value.copyWith(
      levelData: null == levelData
          ? _value.levelData
          : levelData // ignore: cast_nullable_to_non_nullable
              as List<CVLevels>,
      currentNumberOfNodes: null == currentNumberOfNodes
          ? _value.currentNumberOfNodes
          : currentNumberOfNodes // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: freezed == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as CVAnswer?,
      nextLevel: freezed == nextLevel
          ? _value.nextLevel
          : nextLevel // ignore: cast_nullable_to_non_nullable
              as CVAnswer?,
      rect: freezed == rect
          ? _value.rect
          : rect // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LevelStateImplCopyWith<$Res>
    implements $LevelStateCopyWith<$Res> {
  factory _$$LevelStateImplCopyWith(
          _$LevelStateImpl value, $Res Function(_$LevelStateImpl) then) =
      __$$LevelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CVLevels> levelData,
      int currentNumberOfNodes,
      CVAnswer? currentLevel,
      CVAnswer? nextLevel,
      @JsonKey(includeFromJson: false, includeToJson: false) Rect? rect});
}

/// @nodoc
class __$$LevelStateImplCopyWithImpl<$Res>
    extends _$LevelStateCopyWithImpl<$Res, _$LevelStateImpl>
    implements _$$LevelStateImplCopyWith<$Res> {
  __$$LevelStateImplCopyWithImpl(
      _$LevelStateImpl _value, $Res Function(_$LevelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? levelData = null,
    Object? currentNumberOfNodes = null,
    Object? currentLevel = freezed,
    Object? nextLevel = freezed,
    Object? rect = freezed,
  }) {
    return _then(_$LevelStateImpl(
      levelData: null == levelData
          ? _value._levelData
          : levelData // ignore: cast_nullable_to_non_nullable
              as List<CVLevels>,
      currentNumberOfNodes: null == currentNumberOfNodes
          ? _value.currentNumberOfNodes
          : currentNumberOfNodes // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: freezed == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as CVAnswer?,
      nextLevel: freezed == nextLevel
          ? _value.nextLevel
          : nextLevel // ignore: cast_nullable_to_non_nullable
              as CVAnswer?,
      rect: freezed == rect
          ? _value.rect
          : rect // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LevelStateImpl implements _LevelState {
  const _$LevelStateImpl(
      {final List<CVLevels> levelData = const [],
      this.currentNumberOfNodes = 4,
      this.currentLevel,
      this.nextLevel,
      @JsonKey(includeFromJson: false, includeToJson: false) this.rect = null})
      : _levelData = levelData;

  factory _$LevelStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LevelStateImplFromJson(json);

  final List<CVLevels> _levelData;
  @override
  @JsonKey()
  List<CVLevels> get levelData {
    if (_levelData is EqualUnmodifiableListView) return _levelData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_levelData);
  }

  @override
  @JsonKey()
  final int currentNumberOfNodes;
  @override
  final CVAnswer? currentLevel;
  @override
  final CVAnswer? nextLevel;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Rect? rect;

  @override
  String toString() {
    return 'LevelState(levelData: $levelData, currentNumberOfNodes: $currentNumberOfNodes, currentLevel: $currentLevel, nextLevel: $nextLevel, rect: $rect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LevelStateImpl &&
            const DeepCollectionEquality()
                .equals(other._levelData, _levelData) &&
            (identical(other.currentNumberOfNodes, currentNumberOfNodes) ||
                other.currentNumberOfNodes == currentNumberOfNodes) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.nextLevel, nextLevel) ||
                other.nextLevel == nextLevel) &&
            (identical(other.rect, rect) || other.rect == rect));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_levelData),
      currentNumberOfNodes,
      currentLevel,
      nextLevel,
      rect);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LevelStateImplCopyWith<_$LevelStateImpl> get copyWith =>
      __$$LevelStateImplCopyWithImpl<_$LevelStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LevelStateImplToJson(
      this,
    );
  }
}

abstract class _LevelState implements LevelState {
  const factory _LevelState(
      {final List<CVLevels> levelData,
      final int currentNumberOfNodes,
      final CVAnswer? currentLevel,
      final CVAnswer? nextLevel,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final Rect? rect}) = _$LevelStateImpl;

  factory _LevelState.fromJson(Map<String, dynamic> json) =
      _$LevelStateImpl.fromJson;

  @override
  List<CVLevels> get levelData;
  @override
  int get currentNumberOfNodes;
  @override
  CVAnswer? get currentLevel;
  @override
  CVAnswer? get nextLevel;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Rect? get rect;
  @override
  @JsonKey(ignore: true)
  _$$LevelStateImplCopyWith<_$LevelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
