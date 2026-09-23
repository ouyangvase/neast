// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tent_score_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TentScoreModel {

 int get score; int get maxScore; String get ratingLabel; String get streakLabel; String get streakStatus; int get onTimePayments; int get latePayments; String get totalPaid; int get verifiedLeases; String get since;
/// Create a copy of TentScoreModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TentScoreModelCopyWith<TentScoreModel> get copyWith => _$TentScoreModelCopyWithImpl<TentScoreModel>(this as TentScoreModel, _$identity);

  /// Serializes this TentScoreModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TentScoreModel&&(identical(other.score, score) || other.score == score)&&(identical(other.maxScore, maxScore) || other.maxScore == maxScore)&&(identical(other.ratingLabel, ratingLabel) || other.ratingLabel == ratingLabel)&&(identical(other.streakLabel, streakLabel) || other.streakLabel == streakLabel)&&(identical(other.streakStatus, streakStatus) || other.streakStatus == streakStatus)&&(identical(other.onTimePayments, onTimePayments) || other.onTimePayments == onTimePayments)&&(identical(other.latePayments, latePayments) || other.latePayments == latePayments)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.verifiedLeases, verifiedLeases) || other.verifiedLeases == verifiedLeases)&&(identical(other.since, since) || other.since == since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,maxScore,ratingLabel,streakLabel,streakStatus,onTimePayments,latePayments,totalPaid,verifiedLeases,since);

@override
String toString() {
  return 'TentScoreModel(score: $score, maxScore: $maxScore, ratingLabel: $ratingLabel, streakLabel: $streakLabel, streakStatus: $streakStatus, onTimePayments: $onTimePayments, latePayments: $latePayments, totalPaid: $totalPaid, verifiedLeases: $verifiedLeases, since: $since)';
}


}

/// @nodoc
abstract mixin class $TentScoreModelCopyWith<$Res>  {
  factory $TentScoreModelCopyWith(TentScoreModel value, $Res Function(TentScoreModel) _then) = _$TentScoreModelCopyWithImpl;
@useResult
$Res call({
 int score, int maxScore, String ratingLabel, String streakLabel, String streakStatus, int onTimePayments, int latePayments, String totalPaid, int verifiedLeases, String since
});




}
/// @nodoc
class _$TentScoreModelCopyWithImpl<$Res>
    implements $TentScoreModelCopyWith<$Res> {
  _$TentScoreModelCopyWithImpl(this._self, this._then);

  final TentScoreModel _self;
  final $Res Function(TentScoreModel) _then;

/// Create a copy of TentScoreModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? maxScore = null,Object? ratingLabel = null,Object? streakLabel = null,Object? streakStatus = null,Object? onTimePayments = null,Object? latePayments = null,Object? totalPaid = null,Object? verifiedLeases = null,Object? since = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,maxScore: null == maxScore ? _self.maxScore : maxScore // ignore: cast_nullable_to_non_nullable
as int,ratingLabel: null == ratingLabel ? _self.ratingLabel : ratingLabel // ignore: cast_nullable_to_non_nullable
as String,streakLabel: null == streakLabel ? _self.streakLabel : streakLabel // ignore: cast_nullable_to_non_nullable
as String,streakStatus: null == streakStatus ? _self.streakStatus : streakStatus // ignore: cast_nullable_to_non_nullable
as String,onTimePayments: null == onTimePayments ? _self.onTimePayments : onTimePayments // ignore: cast_nullable_to_non_nullable
as int,latePayments: null == latePayments ? _self.latePayments : latePayments // ignore: cast_nullable_to_non_nullable
as int,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String,verifiedLeases: null == verifiedLeases ? _self.verifiedLeases : verifiedLeases // ignore: cast_nullable_to_non_nullable
as int,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TentScoreModel].
extension TentScoreModelPatterns on TentScoreModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TentScoreModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TentScoreModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TentScoreModel value)  $default,){
final _that = this;
switch (_that) {
case _TentScoreModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TentScoreModel value)?  $default,){
final _that = this;
switch (_that) {
case _TentScoreModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  int maxScore,  String ratingLabel,  String streakLabel,  String streakStatus,  int onTimePayments,  int latePayments,  String totalPaid,  int verifiedLeases,  String since)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TentScoreModel() when $default != null:
return $default(_that.score,_that.maxScore,_that.ratingLabel,_that.streakLabel,_that.streakStatus,_that.onTimePayments,_that.latePayments,_that.totalPaid,_that.verifiedLeases,_that.since);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  int maxScore,  String ratingLabel,  String streakLabel,  String streakStatus,  int onTimePayments,  int latePayments,  String totalPaid,  int verifiedLeases,  String since)  $default,) {final _that = this;
switch (_that) {
case _TentScoreModel():
return $default(_that.score,_that.maxScore,_that.ratingLabel,_that.streakLabel,_that.streakStatus,_that.onTimePayments,_that.latePayments,_that.totalPaid,_that.verifiedLeases,_that.since);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  int maxScore,  String ratingLabel,  String streakLabel,  String streakStatus,  int onTimePayments,  int latePayments,  String totalPaid,  int verifiedLeases,  String since)?  $default,) {final _that = this;
switch (_that) {
case _TentScoreModel() when $default != null:
return $default(_that.score,_that.maxScore,_that.ratingLabel,_that.streakLabel,_that.streakStatus,_that.onTimePayments,_that.latePayments,_that.totalPaid,_that.verifiedLeases,_that.since);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TentScoreModel extends TentScoreModel {
  const _TentScoreModel({this.score = 0, this.maxScore = 1000, this.ratingLabel = '', this.streakLabel = '', this.streakStatus = '', this.onTimePayments = 0, this.latePayments = 0, this.totalPaid = '', this.verifiedLeases = 0, this.since = ''}): super._();
  factory _TentScoreModel.fromJson(Map<String, dynamic> json) => _$TentScoreModelFromJson(json);

@override@JsonKey() final  int score;
@override@JsonKey() final  int maxScore;
@override@JsonKey() final  String ratingLabel;
@override@JsonKey() final  String streakLabel;
@override@JsonKey() final  String streakStatus;
@override@JsonKey() final  int onTimePayments;
@override@JsonKey() final  int latePayments;
@override@JsonKey() final  String totalPaid;
@override@JsonKey() final  int verifiedLeases;
@override@JsonKey() final  String since;

/// Create a copy of TentScoreModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TentScoreModelCopyWith<_TentScoreModel> get copyWith => __$TentScoreModelCopyWithImpl<_TentScoreModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TentScoreModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TentScoreModel&&(identical(other.score, score) || other.score == score)&&(identical(other.maxScore, maxScore) || other.maxScore == maxScore)&&(identical(other.ratingLabel, ratingLabel) || other.ratingLabel == ratingLabel)&&(identical(other.streakLabel, streakLabel) || other.streakLabel == streakLabel)&&(identical(other.streakStatus, streakStatus) || other.streakStatus == streakStatus)&&(identical(other.onTimePayments, onTimePayments) || other.onTimePayments == onTimePayments)&&(identical(other.latePayments, latePayments) || other.latePayments == latePayments)&&(identical(other.totalPaid, totalPaid) || other.totalPaid == totalPaid)&&(identical(other.verifiedLeases, verifiedLeases) || other.verifiedLeases == verifiedLeases)&&(identical(other.since, since) || other.since == since));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,maxScore,ratingLabel,streakLabel,streakStatus,onTimePayments,latePayments,totalPaid,verifiedLeases,since);

@override
String toString() {
  return 'TentScoreModel(score: $score, maxScore: $maxScore, ratingLabel: $ratingLabel, streakLabel: $streakLabel, streakStatus: $streakStatus, onTimePayments: $onTimePayments, latePayments: $latePayments, totalPaid: $totalPaid, verifiedLeases: $verifiedLeases, since: $since)';
}


}

/// @nodoc
abstract mixin class _$TentScoreModelCopyWith<$Res> implements $TentScoreModelCopyWith<$Res> {
  factory _$TentScoreModelCopyWith(_TentScoreModel value, $Res Function(_TentScoreModel) _then) = __$TentScoreModelCopyWithImpl;
@override @useResult
$Res call({
 int score, int maxScore, String ratingLabel, String streakLabel, String streakStatus, int onTimePayments, int latePayments, String totalPaid, int verifiedLeases, String since
});




}
/// @nodoc
class __$TentScoreModelCopyWithImpl<$Res>
    implements _$TentScoreModelCopyWith<$Res> {
  __$TentScoreModelCopyWithImpl(this._self, this._then);

  final _TentScoreModel _self;
  final $Res Function(_TentScoreModel) _then;

/// Create a copy of TentScoreModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? maxScore = null,Object? ratingLabel = null,Object? streakLabel = null,Object? streakStatus = null,Object? onTimePayments = null,Object? latePayments = null,Object? totalPaid = null,Object? verifiedLeases = null,Object? since = null,}) {
  return _then(_TentScoreModel(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,maxScore: null == maxScore ? _self.maxScore : maxScore // ignore: cast_nullable_to_non_nullable
as int,ratingLabel: null == ratingLabel ? _self.ratingLabel : ratingLabel // ignore: cast_nullable_to_non_nullable
as String,streakLabel: null == streakLabel ? _self.streakLabel : streakLabel // ignore: cast_nullable_to_non_nullable
as String,streakStatus: null == streakStatus ? _self.streakStatus : streakStatus // ignore: cast_nullable_to_non_nullable
as String,onTimePayments: null == onTimePayments ? _self.onTimePayments : onTimePayments // ignore: cast_nullable_to_non_nullable
as int,latePayments: null == latePayments ? _self.latePayments : latePayments // ignore: cast_nullable_to_non_nullable
as int,totalPaid: null == totalPaid ? _self.totalPaid : totalPaid // ignore: cast_nullable_to_non_nullable
as String,verifiedLeases: null == verifiedLeases ? _self.verifiedLeases : verifiedLeases // ignore: cast_nullable_to_non_nullable
as int,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
