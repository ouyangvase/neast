// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'points_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointsExpiringModel {

 int get points;@JsonKey(name: 'expired_date') String get expiredDate;
/// Create a copy of PointsExpiringModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsExpiringModelCopyWith<PointsExpiringModel> get copyWith => _$PointsExpiringModelCopyWithImpl<PointsExpiringModel>(this as PointsExpiringModel, _$identity);

  /// Serializes this PointsExpiringModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsExpiringModel&&(identical(other.points, points) || other.points == points)&&(identical(other.expiredDate, expiredDate) || other.expiredDate == expiredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,expiredDate);

@override
String toString() {
  return 'PointsExpiringModel(points: $points, expiredDate: $expiredDate)';
}


}

/// @nodoc
abstract mixin class $PointsExpiringModelCopyWith<$Res>  {
  factory $PointsExpiringModelCopyWith(PointsExpiringModel value, $Res Function(PointsExpiringModel) _then) = _$PointsExpiringModelCopyWithImpl;
@useResult
$Res call({
 int points,@JsonKey(name: 'expired_date') String expiredDate
});




}
/// @nodoc
class _$PointsExpiringModelCopyWithImpl<$Res>
    implements $PointsExpiringModelCopyWith<$Res> {
  _$PointsExpiringModelCopyWithImpl(this._self, this._then);

  final PointsExpiringModel _self;
  final $Res Function(PointsExpiringModel) _then;

/// Create a copy of PointsExpiringModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? expiredDate = null,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,expiredDate: null == expiredDate ? _self.expiredDate : expiredDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PointsExpiringModel].
extension PointsExpiringModelPatterns on PointsExpiringModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsExpiringModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsExpiringModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsExpiringModel value)  $default,){
final _that = this;
switch (_that) {
case _PointsExpiringModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsExpiringModel value)?  $default,){
final _that = this;
switch (_that) {
case _PointsExpiringModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int points, @JsonKey(name: 'expired_date')  String expiredDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsExpiringModel() when $default != null:
return $default(_that.points,_that.expiredDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int points, @JsonKey(name: 'expired_date')  String expiredDate)  $default,) {final _that = this;
switch (_that) {
case _PointsExpiringModel():
return $default(_that.points,_that.expiredDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int points, @JsonKey(name: 'expired_date')  String expiredDate)?  $default,) {final _that = this;
switch (_that) {
case _PointsExpiringModel() when $default != null:
return $default(_that.points,_that.expiredDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsExpiringModel extends PointsExpiringModel {
  const _PointsExpiringModel({this.points = 0, @JsonKey(name: 'expired_date') this.expiredDate = ''}): super._();
  factory _PointsExpiringModel.fromJson(Map<String, dynamic> json) => _$PointsExpiringModelFromJson(json);

@override@JsonKey() final  int points;
@override@JsonKey(name: 'expired_date') final  String expiredDate;

/// Create a copy of PointsExpiringModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsExpiringModelCopyWith<_PointsExpiringModel> get copyWith => __$PointsExpiringModelCopyWithImpl<_PointsExpiringModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsExpiringModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsExpiringModel&&(identical(other.points, points) || other.points == points)&&(identical(other.expiredDate, expiredDate) || other.expiredDate == expiredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,expiredDate);

@override
String toString() {
  return 'PointsExpiringModel(points: $points, expiredDate: $expiredDate)';
}


}

/// @nodoc
abstract mixin class _$PointsExpiringModelCopyWith<$Res> implements $PointsExpiringModelCopyWith<$Res> {
  factory _$PointsExpiringModelCopyWith(_PointsExpiringModel value, $Res Function(_PointsExpiringModel) _then) = __$PointsExpiringModelCopyWithImpl;
@override @useResult
$Res call({
 int points,@JsonKey(name: 'expired_date') String expiredDate
});




}
/// @nodoc
class __$PointsExpiringModelCopyWithImpl<$Res>
    implements _$PointsExpiringModelCopyWith<$Res> {
  __$PointsExpiringModelCopyWithImpl(this._self, this._then);

  final _PointsExpiringModel _self;
  final $Res Function(_PointsExpiringModel) _then;

/// Create a copy of PointsExpiringModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? expiredDate = null,}) {
  return _then(_PointsExpiringModel(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,expiredDate: null == expiredDate ? _self.expiredDate : expiredDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PointsDashboardTierModel {

 RewardTierItemModel get current;
/// Create a copy of PointsDashboardTierModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsDashboardTierModelCopyWith<PointsDashboardTierModel> get copyWith => _$PointsDashboardTierModelCopyWithImpl<PointsDashboardTierModel>(this as PointsDashboardTierModel, _$identity);

  /// Serializes this PointsDashboardTierModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsDashboardTierModel&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current);

@override
String toString() {
  return 'PointsDashboardTierModel(current: $current)';
}


}

/// @nodoc
abstract mixin class $PointsDashboardTierModelCopyWith<$Res>  {
  factory $PointsDashboardTierModelCopyWith(PointsDashboardTierModel value, $Res Function(PointsDashboardTierModel) _then) = _$PointsDashboardTierModelCopyWithImpl;
@useResult
$Res call({
 RewardTierItemModel current
});


$RewardTierItemModelCopyWith<$Res> get current;

}
/// @nodoc
class _$PointsDashboardTierModelCopyWithImpl<$Res>
    implements $PointsDashboardTierModelCopyWith<$Res> {
  _$PointsDashboardTierModelCopyWithImpl(this._self, this._then);

  final PointsDashboardTierModel _self;
  final $Res Function(PointsDashboardTierModel) _then;

/// Create a copy of PointsDashboardTierModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = null,}) {
  return _then(_self.copyWith(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as RewardTierItemModel,
  ));
}
/// Create a copy of PointsDashboardTierModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierItemModelCopyWith<$Res> get current {
  
  return $RewardTierItemModelCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}


/// Adds pattern-matching-related methods to [PointsDashboardTierModel].
extension PointsDashboardTierModelPatterns on PointsDashboardTierModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsDashboardTierModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsDashboardTierModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsDashboardTierModel value)  $default,){
final _that = this;
switch (_that) {
case _PointsDashboardTierModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsDashboardTierModel value)?  $default,){
final _that = this;
switch (_that) {
case _PointsDashboardTierModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RewardTierItemModel current)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsDashboardTierModel() when $default != null:
return $default(_that.current);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RewardTierItemModel current)  $default,) {final _that = this;
switch (_that) {
case _PointsDashboardTierModel():
return $default(_that.current);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RewardTierItemModel current)?  $default,) {final _that = this;
switch (_that) {
case _PointsDashboardTierModel() when $default != null:
return $default(_that.current);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsDashboardTierModel implements PointsDashboardTierModel {
  const _PointsDashboardTierModel({this.current = const RewardTierItemModel(id: 1)});
  factory _PointsDashboardTierModel.fromJson(Map<String, dynamic> json) => _$PointsDashboardTierModelFromJson(json);

@override@JsonKey() final  RewardTierItemModel current;

/// Create a copy of PointsDashboardTierModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsDashboardTierModelCopyWith<_PointsDashboardTierModel> get copyWith => __$PointsDashboardTierModelCopyWithImpl<_PointsDashboardTierModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsDashboardTierModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsDashboardTierModel&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current);

@override
String toString() {
  return 'PointsDashboardTierModel(current: $current)';
}


}

/// @nodoc
abstract mixin class _$PointsDashboardTierModelCopyWith<$Res> implements $PointsDashboardTierModelCopyWith<$Res> {
  factory _$PointsDashboardTierModelCopyWith(_PointsDashboardTierModel value, $Res Function(_PointsDashboardTierModel) _then) = __$PointsDashboardTierModelCopyWithImpl;
@override @useResult
$Res call({
 RewardTierItemModel current
});


@override $RewardTierItemModelCopyWith<$Res> get current;

}
/// @nodoc
class __$PointsDashboardTierModelCopyWithImpl<$Res>
    implements _$PointsDashboardTierModelCopyWith<$Res> {
  __$PointsDashboardTierModelCopyWithImpl(this._self, this._then);

  final _PointsDashboardTierModel _self;
  final $Res Function(_PointsDashboardTierModel) _then;

/// Create a copy of PointsDashboardTierModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = null,}) {
  return _then(_PointsDashboardTierModel(
current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as RewardTierItemModel,
  ));
}

/// Create a copy of PointsDashboardTierModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardTierItemModelCopyWith<$Res> get current {
  
  return $RewardTierItemModelCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}
}


/// @nodoc
mixin _$PointsDashboardModel {

 int get points; PointsDashboardTierModel get tier; PointsExpiringModel? get expiring;@JsonKey(name: 'voucher_count') int get voucherCount;@JsonKey(name: 'inviter_reward_points') int get inviterRewardPoints;@JsonKey(name: 'invitee_reward_points') int get inviteeRewardPoints;
/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsDashboardModelCopyWith<PointsDashboardModel> get copyWith => _$PointsDashboardModelCopyWithImpl<PointsDashboardModel>(this as PointsDashboardModel, _$identity);

  /// Serializes this PointsDashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsDashboardModel&&(identical(other.points, points) || other.points == points)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.expiring, expiring) || other.expiring == expiring)&&(identical(other.voucherCount, voucherCount) || other.voucherCount == voucherCount)&&(identical(other.inviterRewardPoints, inviterRewardPoints) || other.inviterRewardPoints == inviterRewardPoints)&&(identical(other.inviteeRewardPoints, inviteeRewardPoints) || other.inviteeRewardPoints == inviteeRewardPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,tier,expiring,voucherCount,inviterRewardPoints,inviteeRewardPoints);

@override
String toString() {
  return 'PointsDashboardModel(points: $points, tier: $tier, expiring: $expiring, voucherCount: $voucherCount, inviterRewardPoints: $inviterRewardPoints, inviteeRewardPoints: $inviteeRewardPoints)';
}


}

/// @nodoc
abstract mixin class $PointsDashboardModelCopyWith<$Res>  {
  factory $PointsDashboardModelCopyWith(PointsDashboardModel value, $Res Function(PointsDashboardModel) _then) = _$PointsDashboardModelCopyWithImpl;
@useResult
$Res call({
 int points, PointsDashboardTierModel tier, PointsExpiringModel? expiring,@JsonKey(name: 'voucher_count') int voucherCount,@JsonKey(name: 'inviter_reward_points') int inviterRewardPoints,@JsonKey(name: 'invitee_reward_points') int inviteeRewardPoints
});


$PointsDashboardTierModelCopyWith<$Res> get tier;$PointsExpiringModelCopyWith<$Res>? get expiring;

}
/// @nodoc
class _$PointsDashboardModelCopyWithImpl<$Res>
    implements $PointsDashboardModelCopyWith<$Res> {
  _$PointsDashboardModelCopyWithImpl(this._self, this._then);

  final PointsDashboardModel _self;
  final $Res Function(PointsDashboardModel) _then;

/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? tier = null,Object? expiring = freezed,Object? voucherCount = null,Object? inviterRewardPoints = null,Object? inviteeRewardPoints = null,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as PointsDashboardTierModel,expiring: freezed == expiring ? _self.expiring : expiring // ignore: cast_nullable_to_non_nullable
as PointsExpiringModel?,voucherCount: null == voucherCount ? _self.voucherCount : voucherCount // ignore: cast_nullable_to_non_nullable
as int,inviterRewardPoints: null == inviterRewardPoints ? _self.inviterRewardPoints : inviterRewardPoints // ignore: cast_nullable_to_non_nullable
as int,inviteeRewardPoints: null == inviteeRewardPoints ? _self.inviteeRewardPoints : inviteeRewardPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointsDashboardTierModelCopyWith<$Res> get tier {
  
  return $PointsDashboardTierModelCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointsExpiringModelCopyWith<$Res>? get expiring {
    if (_self.expiring == null) {
    return null;
  }

  return $PointsExpiringModelCopyWith<$Res>(_self.expiring!, (value) {
    return _then(_self.copyWith(expiring: value));
  });
}
}


/// Adds pattern-matching-related methods to [PointsDashboardModel].
extension PointsDashboardModelPatterns on PointsDashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsDashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsDashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsDashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _PointsDashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsDashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _PointsDashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int points,  PointsDashboardTierModel tier,  PointsExpiringModel? expiring, @JsonKey(name: 'voucher_count')  int voucherCount, @JsonKey(name: 'inviter_reward_points')  int inviterRewardPoints, @JsonKey(name: 'invitee_reward_points')  int inviteeRewardPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsDashboardModel() when $default != null:
return $default(_that.points,_that.tier,_that.expiring,_that.voucherCount,_that.inviterRewardPoints,_that.inviteeRewardPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int points,  PointsDashboardTierModel tier,  PointsExpiringModel? expiring, @JsonKey(name: 'voucher_count')  int voucherCount, @JsonKey(name: 'inviter_reward_points')  int inviterRewardPoints, @JsonKey(name: 'invitee_reward_points')  int inviteeRewardPoints)  $default,) {final _that = this;
switch (_that) {
case _PointsDashboardModel():
return $default(_that.points,_that.tier,_that.expiring,_that.voucherCount,_that.inviterRewardPoints,_that.inviteeRewardPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int points,  PointsDashboardTierModel tier,  PointsExpiringModel? expiring, @JsonKey(name: 'voucher_count')  int voucherCount, @JsonKey(name: 'inviter_reward_points')  int inviterRewardPoints, @JsonKey(name: 'invitee_reward_points')  int inviteeRewardPoints)?  $default,) {final _that = this;
switch (_that) {
case _PointsDashboardModel() when $default != null:
return $default(_that.points,_that.tier,_that.expiring,_that.voucherCount,_that.inviterRewardPoints,_that.inviteeRewardPoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsDashboardModel extends PointsDashboardModel {
  const _PointsDashboardModel({this.points = 0, this.tier = const PointsDashboardTierModel(), this.expiring, @JsonKey(name: 'voucher_count') this.voucherCount = 0, @JsonKey(name: 'inviter_reward_points') this.inviterRewardPoints = 0, @JsonKey(name: 'invitee_reward_points') this.inviteeRewardPoints = 0}): super._();
  factory _PointsDashboardModel.fromJson(Map<String, dynamic> json) => _$PointsDashboardModelFromJson(json);

@override@JsonKey() final  int points;
@override@JsonKey() final  PointsDashboardTierModel tier;
@override final  PointsExpiringModel? expiring;
@override@JsonKey(name: 'voucher_count') final  int voucherCount;
@override@JsonKey(name: 'inviter_reward_points') final  int inviterRewardPoints;
@override@JsonKey(name: 'invitee_reward_points') final  int inviteeRewardPoints;

/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsDashboardModelCopyWith<_PointsDashboardModel> get copyWith => __$PointsDashboardModelCopyWithImpl<_PointsDashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsDashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsDashboardModel&&(identical(other.points, points) || other.points == points)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.expiring, expiring) || other.expiring == expiring)&&(identical(other.voucherCount, voucherCount) || other.voucherCount == voucherCount)&&(identical(other.inviterRewardPoints, inviterRewardPoints) || other.inviterRewardPoints == inviterRewardPoints)&&(identical(other.inviteeRewardPoints, inviteeRewardPoints) || other.inviteeRewardPoints == inviteeRewardPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,tier,expiring,voucherCount,inviterRewardPoints,inviteeRewardPoints);

@override
String toString() {
  return 'PointsDashboardModel(points: $points, tier: $tier, expiring: $expiring, voucherCount: $voucherCount, inviterRewardPoints: $inviterRewardPoints, inviteeRewardPoints: $inviteeRewardPoints)';
}


}

/// @nodoc
abstract mixin class _$PointsDashboardModelCopyWith<$Res> implements $PointsDashboardModelCopyWith<$Res> {
  factory _$PointsDashboardModelCopyWith(_PointsDashboardModel value, $Res Function(_PointsDashboardModel) _then) = __$PointsDashboardModelCopyWithImpl;
@override @useResult
$Res call({
 int points, PointsDashboardTierModel tier, PointsExpiringModel? expiring,@JsonKey(name: 'voucher_count') int voucherCount,@JsonKey(name: 'inviter_reward_points') int inviterRewardPoints,@JsonKey(name: 'invitee_reward_points') int inviteeRewardPoints
});


@override $PointsDashboardTierModelCopyWith<$Res> get tier;@override $PointsExpiringModelCopyWith<$Res>? get expiring;

}
/// @nodoc
class __$PointsDashboardModelCopyWithImpl<$Res>
    implements _$PointsDashboardModelCopyWith<$Res> {
  __$PointsDashboardModelCopyWithImpl(this._self, this._then);

  final _PointsDashboardModel _self;
  final $Res Function(_PointsDashboardModel) _then;

/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? tier = null,Object? expiring = freezed,Object? voucherCount = null,Object? inviterRewardPoints = null,Object? inviteeRewardPoints = null,}) {
  return _then(_PointsDashboardModel(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as PointsDashboardTierModel,expiring: freezed == expiring ? _self.expiring : expiring // ignore: cast_nullable_to_non_nullable
as PointsExpiringModel?,voucherCount: null == voucherCount ? _self.voucherCount : voucherCount // ignore: cast_nullable_to_non_nullable
as int,inviterRewardPoints: null == inviterRewardPoints ? _self.inviterRewardPoints : inviterRewardPoints // ignore: cast_nullable_to_non_nullable
as int,inviteeRewardPoints: null == inviteeRewardPoints ? _self.inviteeRewardPoints : inviteeRewardPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointsDashboardTierModelCopyWith<$Res> get tier {
  
  return $PointsDashboardTierModelCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}/// Create a copy of PointsDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointsExpiringModelCopyWith<$Res>? get expiring {
    if (_self.expiring == null) {
    return null;
  }

  return $PointsExpiringModelCopyWith<$Res>(_self.expiring!, (value) {
    return _then(_self.copyWith(expiring: value));
  });
}
}

// dart format on
