// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refer_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReferDashboardModel {

@JsonKey(name: 'total_earned_points') int get totalEarnedPoints;@JsonKey(name: 'invited_count') int get invitedCount;@JsonKey(name: 'max_invite_limit') int get maxInviteLimit;@JsonKey(name: 'next_reward_points') int get nextRewardPoints;@JsonKey(name: 'invitation_code') String get invitationCode;@JsonKey(name: 'invitee_reward_points') int get inviteeRewardPoints;@JsonKey(name: 'invite_url') String get inviteUrl;
/// Create a copy of ReferDashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReferDashboardModelCopyWith<ReferDashboardModel> get copyWith => _$ReferDashboardModelCopyWithImpl<ReferDashboardModel>(this as ReferDashboardModel, _$identity);

  /// Serializes this ReferDashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReferDashboardModel&&(identical(other.totalEarnedPoints, totalEarnedPoints) || other.totalEarnedPoints == totalEarnedPoints)&&(identical(other.invitedCount, invitedCount) || other.invitedCount == invitedCount)&&(identical(other.maxInviteLimit, maxInviteLimit) || other.maxInviteLimit == maxInviteLimit)&&(identical(other.nextRewardPoints, nextRewardPoints) || other.nextRewardPoints == nextRewardPoints)&&(identical(other.invitationCode, invitationCode) || other.invitationCode == invitationCode)&&(identical(other.inviteeRewardPoints, inviteeRewardPoints) || other.inviteeRewardPoints == inviteeRewardPoints)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEarnedPoints,invitedCount,maxInviteLimit,nextRewardPoints,invitationCode,inviteeRewardPoints,inviteUrl);

@override
String toString() {
  return 'ReferDashboardModel(totalEarnedPoints: $totalEarnedPoints, invitedCount: $invitedCount, maxInviteLimit: $maxInviteLimit, nextRewardPoints: $nextRewardPoints, invitationCode: $invitationCode, inviteeRewardPoints: $inviteeRewardPoints, inviteUrl: $inviteUrl)';
}


}

/// @nodoc
abstract mixin class $ReferDashboardModelCopyWith<$Res>  {
  factory $ReferDashboardModelCopyWith(ReferDashboardModel value, $Res Function(ReferDashboardModel) _then) = _$ReferDashboardModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_earned_points') int totalEarnedPoints,@JsonKey(name: 'invited_count') int invitedCount,@JsonKey(name: 'max_invite_limit') int maxInviteLimit,@JsonKey(name: 'next_reward_points') int nextRewardPoints,@JsonKey(name: 'invitation_code') String invitationCode,@JsonKey(name: 'invitee_reward_points') int inviteeRewardPoints,@JsonKey(name: 'invite_url') String inviteUrl
});




}
/// @nodoc
class _$ReferDashboardModelCopyWithImpl<$Res>
    implements $ReferDashboardModelCopyWith<$Res> {
  _$ReferDashboardModelCopyWithImpl(this._self, this._then);

  final ReferDashboardModel _self;
  final $Res Function(ReferDashboardModel) _then;

/// Create a copy of ReferDashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalEarnedPoints = null,Object? invitedCount = null,Object? maxInviteLimit = null,Object? nextRewardPoints = null,Object? invitationCode = null,Object? inviteeRewardPoints = null,Object? inviteUrl = null,}) {
  return _then(_self.copyWith(
totalEarnedPoints: null == totalEarnedPoints ? _self.totalEarnedPoints : totalEarnedPoints // ignore: cast_nullable_to_non_nullable
as int,invitedCount: null == invitedCount ? _self.invitedCount : invitedCount // ignore: cast_nullable_to_non_nullable
as int,maxInviteLimit: null == maxInviteLimit ? _self.maxInviteLimit : maxInviteLimit // ignore: cast_nullable_to_non_nullable
as int,nextRewardPoints: null == nextRewardPoints ? _self.nextRewardPoints : nextRewardPoints // ignore: cast_nullable_to_non_nullable
as int,invitationCode: null == invitationCode ? _self.invitationCode : invitationCode // ignore: cast_nullable_to_non_nullable
as String,inviteeRewardPoints: null == inviteeRewardPoints ? _self.inviteeRewardPoints : inviteeRewardPoints // ignore: cast_nullable_to_non_nullable
as int,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReferDashboardModel].
extension ReferDashboardModelPatterns on ReferDashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReferDashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReferDashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReferDashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _ReferDashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReferDashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReferDashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_earned_points')  int totalEarnedPoints, @JsonKey(name: 'invited_count')  int invitedCount, @JsonKey(name: 'max_invite_limit')  int maxInviteLimit, @JsonKey(name: 'next_reward_points')  int nextRewardPoints, @JsonKey(name: 'invitation_code')  String invitationCode, @JsonKey(name: 'invitee_reward_points')  int inviteeRewardPoints, @JsonKey(name: 'invite_url')  String inviteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReferDashboardModel() when $default != null:
return $default(_that.totalEarnedPoints,_that.invitedCount,_that.maxInviteLimit,_that.nextRewardPoints,_that.invitationCode,_that.inviteeRewardPoints,_that.inviteUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_earned_points')  int totalEarnedPoints, @JsonKey(name: 'invited_count')  int invitedCount, @JsonKey(name: 'max_invite_limit')  int maxInviteLimit, @JsonKey(name: 'next_reward_points')  int nextRewardPoints, @JsonKey(name: 'invitation_code')  String invitationCode, @JsonKey(name: 'invitee_reward_points')  int inviteeRewardPoints, @JsonKey(name: 'invite_url')  String inviteUrl)  $default,) {final _that = this;
switch (_that) {
case _ReferDashboardModel():
return $default(_that.totalEarnedPoints,_that.invitedCount,_that.maxInviteLimit,_that.nextRewardPoints,_that.invitationCode,_that.inviteeRewardPoints,_that.inviteUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_earned_points')  int totalEarnedPoints, @JsonKey(name: 'invited_count')  int invitedCount, @JsonKey(name: 'max_invite_limit')  int maxInviteLimit, @JsonKey(name: 'next_reward_points')  int nextRewardPoints, @JsonKey(name: 'invitation_code')  String invitationCode, @JsonKey(name: 'invitee_reward_points')  int inviteeRewardPoints, @JsonKey(name: 'invite_url')  String inviteUrl)?  $default,) {final _that = this;
switch (_that) {
case _ReferDashboardModel() when $default != null:
return $default(_that.totalEarnedPoints,_that.invitedCount,_that.maxInviteLimit,_that.nextRewardPoints,_that.invitationCode,_that.inviteeRewardPoints,_that.inviteUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReferDashboardModel extends ReferDashboardModel {
  const _ReferDashboardModel({@JsonKey(name: 'total_earned_points') this.totalEarnedPoints = 0, @JsonKey(name: 'invited_count') this.invitedCount = 0, @JsonKey(name: 'max_invite_limit') this.maxInviteLimit = 4, @JsonKey(name: 'next_reward_points') this.nextRewardPoints = 0, @JsonKey(name: 'invitation_code') this.invitationCode = '', @JsonKey(name: 'invitee_reward_points') this.inviteeRewardPoints = 0, @JsonKey(name: 'invite_url') this.inviteUrl = ''}): super._();
  factory _ReferDashboardModel.fromJson(Map<String, dynamic> json) => _$ReferDashboardModelFromJson(json);

@override@JsonKey(name: 'total_earned_points') final  int totalEarnedPoints;
@override@JsonKey(name: 'invited_count') final  int invitedCount;
@override@JsonKey(name: 'max_invite_limit') final  int maxInviteLimit;
@override@JsonKey(name: 'next_reward_points') final  int nextRewardPoints;
@override@JsonKey(name: 'invitation_code') final  String invitationCode;
@override@JsonKey(name: 'invitee_reward_points') final  int inviteeRewardPoints;
@override@JsonKey(name: 'invite_url') final  String inviteUrl;

/// Create a copy of ReferDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReferDashboardModelCopyWith<_ReferDashboardModel> get copyWith => __$ReferDashboardModelCopyWithImpl<_ReferDashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReferDashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReferDashboardModel&&(identical(other.totalEarnedPoints, totalEarnedPoints) || other.totalEarnedPoints == totalEarnedPoints)&&(identical(other.invitedCount, invitedCount) || other.invitedCount == invitedCount)&&(identical(other.maxInviteLimit, maxInviteLimit) || other.maxInviteLimit == maxInviteLimit)&&(identical(other.nextRewardPoints, nextRewardPoints) || other.nextRewardPoints == nextRewardPoints)&&(identical(other.invitationCode, invitationCode) || other.invitationCode == invitationCode)&&(identical(other.inviteeRewardPoints, inviteeRewardPoints) || other.inviteeRewardPoints == inviteeRewardPoints)&&(identical(other.inviteUrl, inviteUrl) || other.inviteUrl == inviteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalEarnedPoints,invitedCount,maxInviteLimit,nextRewardPoints,invitationCode,inviteeRewardPoints,inviteUrl);

@override
String toString() {
  return 'ReferDashboardModel(totalEarnedPoints: $totalEarnedPoints, invitedCount: $invitedCount, maxInviteLimit: $maxInviteLimit, nextRewardPoints: $nextRewardPoints, invitationCode: $invitationCode, inviteeRewardPoints: $inviteeRewardPoints, inviteUrl: $inviteUrl)';
}


}

/// @nodoc
abstract mixin class _$ReferDashboardModelCopyWith<$Res> implements $ReferDashboardModelCopyWith<$Res> {
  factory _$ReferDashboardModelCopyWith(_ReferDashboardModel value, $Res Function(_ReferDashboardModel) _then) = __$ReferDashboardModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_earned_points') int totalEarnedPoints,@JsonKey(name: 'invited_count') int invitedCount,@JsonKey(name: 'max_invite_limit') int maxInviteLimit,@JsonKey(name: 'next_reward_points') int nextRewardPoints,@JsonKey(name: 'invitation_code') String invitationCode,@JsonKey(name: 'invitee_reward_points') int inviteeRewardPoints,@JsonKey(name: 'invite_url') String inviteUrl
});




}
/// @nodoc
class __$ReferDashboardModelCopyWithImpl<$Res>
    implements _$ReferDashboardModelCopyWith<$Res> {
  __$ReferDashboardModelCopyWithImpl(this._self, this._then);

  final _ReferDashboardModel _self;
  final $Res Function(_ReferDashboardModel) _then;

/// Create a copy of ReferDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalEarnedPoints = null,Object? invitedCount = null,Object? maxInviteLimit = null,Object? nextRewardPoints = null,Object? invitationCode = null,Object? inviteeRewardPoints = null,Object? inviteUrl = null,}) {
  return _then(_ReferDashboardModel(
totalEarnedPoints: null == totalEarnedPoints ? _self.totalEarnedPoints : totalEarnedPoints // ignore: cast_nullable_to_non_nullable
as int,invitedCount: null == invitedCount ? _self.invitedCount : invitedCount // ignore: cast_nullable_to_non_nullable
as int,maxInviteLimit: null == maxInviteLimit ? _self.maxInviteLimit : maxInviteLimit // ignore: cast_nullable_to_non_nullable
as int,nextRewardPoints: null == nextRewardPoints ? _self.nextRewardPoints : nextRewardPoints // ignore: cast_nullable_to_non_nullable
as int,invitationCode: null == invitationCode ? _self.invitationCode : invitationCode // ignore: cast_nullable_to_non_nullable
as String,inviteeRewardPoints: null == inviteeRewardPoints ? _self.inviteeRewardPoints : inviteeRewardPoints // ignore: cast_nullable_to_non_nullable
as int,inviteUrl: null == inviteUrl ? _self.inviteUrl : inviteUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
