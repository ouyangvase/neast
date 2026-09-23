// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewardTierItemModel {

 int get id; String get name;@JsonKey(name: 'min_points') int get minPoints;@JsonKey(name: 'max_points') int get maxPoints;
/// Create a copy of RewardTierItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardTierItemModelCopyWith<RewardTierItemModel> get copyWith => _$RewardTierItemModelCopyWithImpl<RewardTierItemModel>(this as RewardTierItemModel, _$identity);

  /// Serializes this RewardTierItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardTierItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minPoints, minPoints) || other.minPoints == minPoints)&&(identical(other.maxPoints, maxPoints) || other.maxPoints == maxPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,minPoints,maxPoints);

@override
String toString() {
  return 'RewardTierItemModel(id: $id, name: $name, minPoints: $minPoints, maxPoints: $maxPoints)';
}


}

/// @nodoc
abstract mixin class $RewardTierItemModelCopyWith<$Res>  {
  factory $RewardTierItemModelCopyWith(RewardTierItemModel value, $Res Function(RewardTierItemModel) _then) = _$RewardTierItemModelCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'min_points') int minPoints,@JsonKey(name: 'max_points') int maxPoints
});




}
/// @nodoc
class _$RewardTierItemModelCopyWithImpl<$Res>
    implements $RewardTierItemModelCopyWith<$Res> {
  _$RewardTierItemModelCopyWithImpl(this._self, this._then);

  final RewardTierItemModel _self;
  final $Res Function(RewardTierItemModel) _then;

/// Create a copy of RewardTierItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? minPoints = null,Object? maxPoints = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minPoints: null == minPoints ? _self.minPoints : minPoints // ignore: cast_nullable_to_non_nullable
as int,maxPoints: null == maxPoints ? _self.maxPoints : maxPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RewardTierItemModel].
extension RewardTierItemModelPatterns on RewardTierItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardTierItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardTierItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardTierItemModel value)  $default,){
final _that = this;
switch (_that) {
case _RewardTierItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardTierItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _RewardTierItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'min_points')  int minPoints, @JsonKey(name: 'max_points')  int maxPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardTierItemModel() when $default != null:
return $default(_that.id,_that.name,_that.minPoints,_that.maxPoints);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'min_points')  int minPoints, @JsonKey(name: 'max_points')  int maxPoints)  $default,) {final _that = this;
switch (_that) {
case _RewardTierItemModel():
return $default(_that.id,_that.name,_that.minPoints,_that.maxPoints);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'min_points')  int minPoints, @JsonKey(name: 'max_points')  int maxPoints)?  $default,) {final _that = this;
switch (_that) {
case _RewardTierItemModel() when $default != null:
return $default(_that.id,_that.name,_that.minPoints,_that.maxPoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RewardTierItemModel extends RewardTierItemModel {
  const _RewardTierItemModel({required this.id, this.name = '', @JsonKey(name: 'min_points') this.minPoints = 0, @JsonKey(name: 'max_points') this.maxPoints = 0}): super._();
  factory _RewardTierItemModel.fromJson(Map<String, dynamic> json) => _$RewardTierItemModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'min_points') final  int minPoints;
@override@JsonKey(name: 'max_points') final  int maxPoints;

/// Create a copy of RewardTierItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardTierItemModelCopyWith<_RewardTierItemModel> get copyWith => __$RewardTierItemModelCopyWithImpl<_RewardTierItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardTierItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardTierItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.minPoints, minPoints) || other.minPoints == minPoints)&&(identical(other.maxPoints, maxPoints) || other.maxPoints == maxPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,minPoints,maxPoints);

@override
String toString() {
  return 'RewardTierItemModel(id: $id, name: $name, minPoints: $minPoints, maxPoints: $maxPoints)';
}


}

/// @nodoc
abstract mixin class _$RewardTierItemModelCopyWith<$Res> implements $RewardTierItemModelCopyWith<$Res> {
  factory _$RewardTierItemModelCopyWith(_RewardTierItemModel value, $Res Function(_RewardTierItemModel) _then) = __$RewardTierItemModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'min_points') int minPoints,@JsonKey(name: 'max_points') int maxPoints
});




}
/// @nodoc
class __$RewardTierItemModelCopyWithImpl<$Res>
    implements _$RewardTierItemModelCopyWith<$Res> {
  __$RewardTierItemModelCopyWithImpl(this._self, this._then);

  final _RewardTierItemModel _self;
  final $Res Function(_RewardTierItemModel) _then;

/// Create a copy of RewardTierItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? minPoints = null,Object? maxPoints = null,}) {
  return _then(_RewardTierItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,minPoints: null == minPoints ? _self.minPoints : minPoints // ignore: cast_nullable_to_non_nullable
as int,maxPoints: null == maxPoints ? _self.maxPoints : maxPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RewardTierProgressModel {

 RewardTierItemModel get current; RewardTierItemModel? get next;@JsonKey(name: 'pointsToNextTier') int get pointsToNextTier;@JsonKey(name: 'progressCurrent') int get progressCurrent;@JsonKey(name: 'progressTarget') int get progressTarget;
/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardTierProgressModelCopyWith<RewardTierProgressModel> get copyWith => _$RewardTierProgressModelCopyWithImpl<RewardTierProgressModel>(this as RewardTierProgressModel, _$identity);

  /// Serializes this RewardTierProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardTierProgressModel&&(identical(other.current, current) || other.current == current)&&(identical(other.next, next) || other.next == next)&&(identical(other.pointsToNextTier, pointsToNextTier) || other.pointsToNextTier == pointsToNextTier)&&(identical(other.progressCurrent, progressCurrent) || other.progressCurrent == progressCurrent)&&(identical(other.progressTarget, progressTarget) || other.progressTarget == progressTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,next,pointsToNextTier,progressCurrent,progressTarget);

@override
String toString() {
  return 'RewardTierProgressModel(current: $current, next: $next, pointsToNextTier: $pointsToNextTier, progressCurrent: $progressCurrent, progressTarget: $progressTarget)';
}


}

/// @nodoc
abstract mixin class $RewardTierProgressModelCopyWith<$Res>  {
  factory $RewardTierProgressModelCopyWith(RewardTierProgressModel value, $Res Function(RewardTierProgressModel) _then) = _$RewardTierProgressModelCopyWithImpl;
@useResult
$Res call({
 RewardTierItemModel current, RewardTierItemModel? next,@JsonKey(name: 'pointsToNextTier') int pointsToNextTier,@JsonKey(name: 'progressCurrent') int progressCurrent,@JsonKey(name: 'progressTarget') int progressTarget
});


$RewardTierItemModelCopyWith<$Res> get current;$RewardTierItemModelCopyWith<$Res>? get next;

}
/// @nodoc
class _$RewardTierProgressModelCopyWithImpl<$Res>
    implements $RewardTierProgressModelCopyWith<$Res> {
  _$RewardTierProgressModelCopyWithImpl(this._self, this._then);

  final RewardTierProgressModel _self;
  final $Res Function(RewardTierProgressModel) _then;

/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,Object? next = freezed,Object? pointsToNextTier = null,Object? progressCurrent = null,Object? progressTarget = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as RewardTierItemModel,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as RewardTierItemModel?,pointsToNextTier: null == pointsToNextTier ? _self.pointsToNextTier : pointsToNextTier // ignore: cast_nullable_to_non_nullable
as int,progressCurrent: null == progressCurrent ? _self.progressCurrent : progressCurrent // ignore: cast_nullable_to_non_nullable
as int,progressTarget: null == progressTarget ? _self.progressTarget : progressTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierItemModelCopyWith<$Res> get current {
  
  return $RewardTierItemModelCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierItemModelCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $RewardTierItemModelCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}


/// Adds pattern-matching-related methods to [RewardTierProgressModel].
extension RewardTierProgressModelPatterns on RewardTierProgressModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardTierProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardTierProgressModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardTierProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _RewardTierProgressModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardTierProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _RewardTierProgressModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RewardTierItemModel current,  RewardTierItemModel? next, @JsonKey(name: 'pointsToNextTier')  int pointsToNextTier, @JsonKey(name: 'progressCurrent')  int progressCurrent, @JsonKey(name: 'progressTarget')  int progressTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardTierProgressModel() when $default != null:
return $default(_that.current,_that.next,_that.pointsToNextTier,_that.progressCurrent,_that.progressTarget);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RewardTierItemModel current,  RewardTierItemModel? next, @JsonKey(name: 'pointsToNextTier')  int pointsToNextTier, @JsonKey(name: 'progressCurrent')  int progressCurrent, @JsonKey(name: 'progressTarget')  int progressTarget)  $default,) {final _that = this;
switch (_that) {
case _RewardTierProgressModel():
return $default(_that.current,_that.next,_that.pointsToNextTier,_that.progressCurrent,_that.progressTarget);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RewardTierItemModel current,  RewardTierItemModel? next, @JsonKey(name: 'pointsToNextTier')  int pointsToNextTier, @JsonKey(name: 'progressCurrent')  int progressCurrent, @JsonKey(name: 'progressTarget')  int progressTarget)?  $default,) {final _that = this;
switch (_that) {
case _RewardTierProgressModel() when $default != null:
return $default(_that.current,_that.next,_that.pointsToNextTier,_that.progressCurrent,_that.progressTarget);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RewardTierProgressModel extends RewardTierProgressModel {
  const _RewardTierProgressModel({required this.current, this.next, @JsonKey(name: 'pointsToNextTier') this.pointsToNextTier = 0, @JsonKey(name: 'progressCurrent') this.progressCurrent = 0, @JsonKey(name: 'progressTarget') this.progressTarget = 0}): super._();
  factory _RewardTierProgressModel.fromJson(Map<String, dynamic> json) => _$RewardTierProgressModelFromJson(json);

@override final  RewardTierItemModel current;
@override final  RewardTierItemModel? next;
@override@JsonKey(name: 'pointsToNextTier') final  int pointsToNextTier;
@override@JsonKey(name: 'progressCurrent') final  int progressCurrent;
@override@JsonKey(name: 'progressTarget') final  int progressTarget;

/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardTierProgressModelCopyWith<_RewardTierProgressModel> get copyWith => __$RewardTierProgressModelCopyWithImpl<_RewardTierProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardTierProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardTierProgressModel&&(identical(other.current, current) || other.current == current)&&(identical(other.next, next) || other.next == next)&&(identical(other.pointsToNextTier, pointsToNextTier) || other.pointsToNextTier == pointsToNextTier)&&(identical(other.progressCurrent, progressCurrent) || other.progressCurrent == progressCurrent)&&(identical(other.progressTarget, progressTarget) || other.progressTarget == progressTarget));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,next,pointsToNextTier,progressCurrent,progressTarget);

@override
String toString() {
  return 'RewardTierProgressModel(current: $current, next: $next, pointsToNextTier: $pointsToNextTier, progressCurrent: $progressCurrent, progressTarget: $progressTarget)';
}


}

/// @nodoc
abstract mixin class _$RewardTierProgressModelCopyWith<$Res> implements $RewardTierProgressModelCopyWith<$Res> {
  factory _$RewardTierProgressModelCopyWith(_RewardTierProgressModel value, $Res Function(_RewardTierProgressModel) _then) = __$RewardTierProgressModelCopyWithImpl;
@override @useResult
$Res call({
 RewardTierItemModel current, RewardTierItemModel? next,@JsonKey(name: 'pointsToNextTier') int pointsToNextTier,@JsonKey(name: 'progressCurrent') int progressCurrent,@JsonKey(name: 'progressTarget') int progressTarget
});


@override $RewardTierItemModelCopyWith<$Res> get current;@override $RewardTierItemModelCopyWith<$Res>? get next;

}
/// @nodoc
class __$RewardTierProgressModelCopyWithImpl<$Res>
    implements _$RewardTierProgressModelCopyWith<$Res> {
  __$RewardTierProgressModelCopyWithImpl(this._self, this._then);

  final _RewardTierProgressModel _self;
  final $Res Function(_RewardTierProgressModel) _then;

/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,Object? next = freezed,Object? pointsToNextTier = null,Object? progressCurrent = null,Object? progressTarget = null,}) {
  return _then(_RewardTierProgressModel(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as RewardTierItemModel,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as RewardTierItemModel?,pointsToNextTier: null == pointsToNextTier ? _self.pointsToNextTier : pointsToNextTier // ignore: cast_nullable_to_non_nullable
as int,progressCurrent: null == progressCurrent ? _self.progressCurrent : progressCurrent // ignore: cast_nullable_to_non_nullable
as int,progressTarget: null == progressTarget ? _self.progressTarget : progressTarget // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierItemModelCopyWith<$Res> get current {
  
  return $RewardTierItemModelCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of RewardTierProgressModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierItemModelCopyWith<$Res>? get next {
    if (_self.next == null) {
    return null;
  }

  return $RewardTierItemModelCopyWith<$Res>(_self.next!, (value) {
    return _then(_self.copyWith(next: value));
  });
}
}


/// @nodoc
mixin _$RewardDashboardModel {

@JsonKey(name: 'points') int get points;@JsonKey(name: 'pointsExpiringText') String get pointsExpiringText; RewardTierProgressModel get tier; List<RewardTierItemModel> get tiers;@JsonKey(name: 'featuredRewards') List<CouponListItemModel> get featuredRewards;@JsonKey(name: 'nearbyRewards') List<MerchantModel> get nearbyRewards;
/// Create a copy of RewardDashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardDashboardModelCopyWith<RewardDashboardModel> get copyWith => _$RewardDashboardModelCopyWithImpl<RewardDashboardModel>(this as RewardDashboardModel, _$identity);

  /// Serializes this RewardDashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardDashboardModel&&(identical(other.points, points) || other.points == points)&&(identical(other.pointsExpiringText, pointsExpiringText) || other.pointsExpiringText == pointsExpiringText)&&(identical(other.tier, tier) || other.tier == tier)&&const DeepCollectionEquality().equals(other.tiers, tiers)&&const DeepCollectionEquality().equals(other.featuredRewards, featuredRewards)&&const DeepCollectionEquality().equals(other.nearbyRewards, nearbyRewards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,pointsExpiringText,tier,const DeepCollectionEquality().hash(tiers),const DeepCollectionEquality().hash(featuredRewards),const DeepCollectionEquality().hash(nearbyRewards));

@override
String toString() {
  return 'RewardDashboardModel(points: $points, pointsExpiringText: $pointsExpiringText, tier: $tier, tiers: $tiers, featuredRewards: $featuredRewards, nearbyRewards: $nearbyRewards)';
}


}

/// @nodoc
abstract mixin class $RewardDashboardModelCopyWith<$Res>  {
  factory $RewardDashboardModelCopyWith(RewardDashboardModel value, $Res Function(RewardDashboardModel) _then) = _$RewardDashboardModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'points') int points,@JsonKey(name: 'pointsExpiringText') String pointsExpiringText, RewardTierProgressModel tier, List<RewardTierItemModel> tiers,@JsonKey(name: 'featuredRewards') List<CouponListItemModel> featuredRewards,@JsonKey(name: 'nearbyRewards') List<MerchantModel> nearbyRewards
});


$RewardTierProgressModelCopyWith<$Res> get tier;

}
/// @nodoc
class _$RewardDashboardModelCopyWithImpl<$Res>
    implements $RewardDashboardModelCopyWith<$Res> {
  _$RewardDashboardModelCopyWithImpl(this._self, this._then);

  final RewardDashboardModel _self;
  final $Res Function(RewardDashboardModel) _then;

/// Create a copy of RewardDashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? pointsExpiringText = null,Object? tier = null,Object? tiers = null,Object? featuredRewards = null,Object? nearbyRewards = null,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,pointsExpiringText: null == pointsExpiringText ? _self.pointsExpiringText : pointsExpiringText // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as RewardTierProgressModel,tiers: null == tiers ? _self.tiers : tiers // ignore: cast_nullable_to_non_nullable
as List<RewardTierItemModel>,featuredRewards: null == featuredRewards ? _self.featuredRewards : featuredRewards // ignore: cast_nullable_to_non_nullable
as List<CouponListItemModel>,nearbyRewards: null == nearbyRewards ? _self.nearbyRewards : nearbyRewards // ignore: cast_nullable_to_non_nullable
as List<MerchantModel>,
  ));
}
/// Create a copy of RewardDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierProgressModelCopyWith<$Res> get tier {
  
  return $RewardTierProgressModelCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}
}


/// Adds pattern-matching-related methods to [RewardDashboardModel].
extension RewardDashboardModelPatterns on RewardDashboardModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardDashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardDashboardModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardDashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _RewardDashboardModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardDashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _RewardDashboardModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'points')  int points, @JsonKey(name: 'pointsExpiringText')  String pointsExpiringText,  RewardTierProgressModel tier,  List<RewardTierItemModel> tiers, @JsonKey(name: 'featuredRewards')  List<CouponListItemModel> featuredRewards, @JsonKey(name: 'nearbyRewards')  List<MerchantModel> nearbyRewards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardDashboardModel() when $default != null:
return $default(_that.points,_that.pointsExpiringText,_that.tier,_that.tiers,_that.featuredRewards,_that.nearbyRewards);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'points')  int points, @JsonKey(name: 'pointsExpiringText')  String pointsExpiringText,  RewardTierProgressModel tier,  List<RewardTierItemModel> tiers, @JsonKey(name: 'featuredRewards')  List<CouponListItemModel> featuredRewards, @JsonKey(name: 'nearbyRewards')  List<MerchantModel> nearbyRewards)  $default,) {final _that = this;
switch (_that) {
case _RewardDashboardModel():
return $default(_that.points,_that.pointsExpiringText,_that.tier,_that.tiers,_that.featuredRewards,_that.nearbyRewards);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'points')  int points, @JsonKey(name: 'pointsExpiringText')  String pointsExpiringText,  RewardTierProgressModel tier,  List<RewardTierItemModel> tiers, @JsonKey(name: 'featuredRewards')  List<CouponListItemModel> featuredRewards, @JsonKey(name: 'nearbyRewards')  List<MerchantModel> nearbyRewards)?  $default,) {final _that = this;
switch (_that) {
case _RewardDashboardModel() when $default != null:
return $default(_that.points,_that.pointsExpiringText,_that.tier,_that.tiers,_that.featuredRewards,_that.nearbyRewards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RewardDashboardModel extends RewardDashboardModel {
  const _RewardDashboardModel({@JsonKey(name: 'points') this.points = 0, @JsonKey(name: 'pointsExpiringText') this.pointsExpiringText = '', this.tier = const RewardTierProgressModel(current: RewardTierItemModel(id: 1)), final  List<RewardTierItemModel> tiers = const [], @JsonKey(name: 'featuredRewards') final  List<CouponListItemModel> featuredRewards = const [], @JsonKey(name: 'nearbyRewards') final  List<MerchantModel> nearbyRewards = const []}): _tiers = tiers,_featuredRewards = featuredRewards,_nearbyRewards = nearbyRewards,super._();
  factory _RewardDashboardModel.fromJson(Map<String, dynamic> json) => _$RewardDashboardModelFromJson(json);

@override@JsonKey(name: 'points') final  int points;
@override@JsonKey(name: 'pointsExpiringText') final  String pointsExpiringText;
@override@JsonKey() final  RewardTierProgressModel tier;
 final  List<RewardTierItemModel> _tiers;
@override@JsonKey() List<RewardTierItemModel> get tiers {
  if (_tiers is EqualUnmodifiableListView) return _tiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiers);
}

 final  List<CouponListItemModel> _featuredRewards;
@override@JsonKey(name: 'featuredRewards') List<CouponListItemModel> get featuredRewards {
  if (_featuredRewards is EqualUnmodifiableListView) return _featuredRewards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuredRewards);
}

 final  List<MerchantModel> _nearbyRewards;
@override@JsonKey(name: 'nearbyRewards') List<MerchantModel> get nearbyRewards {
  if (_nearbyRewards is EqualUnmodifiableListView) return _nearbyRewards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nearbyRewards);
}


/// Create a copy of RewardDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardDashboardModelCopyWith<_RewardDashboardModel> get copyWith => __$RewardDashboardModelCopyWithImpl<_RewardDashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardDashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardDashboardModel&&(identical(other.points, points) || other.points == points)&&(identical(other.pointsExpiringText, pointsExpiringText) || other.pointsExpiringText == pointsExpiringText)&&(identical(other.tier, tier) || other.tier == tier)&&const DeepCollectionEquality().equals(other._tiers, _tiers)&&const DeepCollectionEquality().equals(other._featuredRewards, _featuredRewards)&&const DeepCollectionEquality().equals(other._nearbyRewards, _nearbyRewards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,pointsExpiringText,tier,const DeepCollectionEquality().hash(_tiers),const DeepCollectionEquality().hash(_featuredRewards),const DeepCollectionEquality().hash(_nearbyRewards));

@override
String toString() {
  return 'RewardDashboardModel(points: $points, pointsExpiringText: $pointsExpiringText, tier: $tier, tiers: $tiers, featuredRewards: $featuredRewards, nearbyRewards: $nearbyRewards)';
}


}

/// @nodoc
abstract mixin class _$RewardDashboardModelCopyWith<$Res> implements $RewardDashboardModelCopyWith<$Res> {
  factory _$RewardDashboardModelCopyWith(_RewardDashboardModel value, $Res Function(_RewardDashboardModel) _then) = __$RewardDashboardModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'points') int points,@JsonKey(name: 'pointsExpiringText') String pointsExpiringText, RewardTierProgressModel tier, List<RewardTierItemModel> tiers,@JsonKey(name: 'featuredRewards') List<CouponListItemModel> featuredRewards,@JsonKey(name: 'nearbyRewards') List<MerchantModel> nearbyRewards
});


@override $RewardTierProgressModelCopyWith<$Res> get tier;

}
/// @nodoc
class __$RewardDashboardModelCopyWithImpl<$Res>
    implements _$RewardDashboardModelCopyWith<$Res> {
  __$RewardDashboardModelCopyWithImpl(this._self, this._then);

  final _RewardDashboardModel _self;
  final $Res Function(_RewardDashboardModel) _then;

/// Create a copy of RewardDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? pointsExpiringText = null,Object? tier = null,Object? tiers = null,Object? featuredRewards = null,Object? nearbyRewards = null,}) {
  return _then(_RewardDashboardModel(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,pointsExpiringText: null == pointsExpiringText ? _self.pointsExpiringText : pointsExpiringText // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as RewardTierProgressModel,tiers: null == tiers ? _self._tiers : tiers // ignore: cast_nullable_to_non_nullable
as List<RewardTierItemModel>,featuredRewards: null == featuredRewards ? _self._featuredRewards : featuredRewards // ignore: cast_nullable_to_non_nullable
as List<CouponListItemModel>,nearbyRewards: null == nearbyRewards ? _self._nearbyRewards : nearbyRewards // ignore: cast_nullable_to_non_nullable
as List<MerchantModel>,
  ));
}

/// Create a copy of RewardDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierProgressModelCopyWith<$Res> get tier {
  
  return $RewardTierProgressModelCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}
}

// dart format on
