// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileModel {

 String get userId; String get account; String get email; String get firstName; String get lastName; String get idType; String get idNumber; String? get idValidUntil; String get address; bool get profileCompleted; int get points; double get pointsApproxRm; String get qrCode;
/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileModelCopyWith<UserProfileModel> get copyWith => _$UserProfileModelCopyWithImpl<UserProfileModel>(this as UserProfileModel, _$identity);

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.account, account) || other.account == account)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.idValidUntil, idValidUntil) || other.idValidUntil == idValidUntil)&&(identical(other.address, address) || other.address == address)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.points, points) || other.points == points)&&(identical(other.pointsApproxRm, pointsApproxRm) || other.pointsApproxRm == pointsApproxRm)&&(identical(other.qrCode, qrCode) || other.qrCode == qrCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,account,email,firstName,lastName,idType,idNumber,idValidUntil,address,profileCompleted,points,pointsApproxRm,qrCode);

@override
String toString() {
  return 'UserProfileModel(userId: $userId, account: $account, email: $email, firstName: $firstName, lastName: $lastName, idType: $idType, idNumber: $idNumber, idValidUntil: $idValidUntil, address: $address, profileCompleted: $profileCompleted, points: $points, pointsApproxRm: $pointsApproxRm, qrCode: $qrCode)';
}


}

/// @nodoc
abstract mixin class $UserProfileModelCopyWith<$Res>  {
  factory $UserProfileModelCopyWith(UserProfileModel value, $Res Function(UserProfileModel) _then) = _$UserProfileModelCopyWithImpl;
@useResult
$Res call({
 String userId, String account, String email, String firstName, String lastName, String idType, String idNumber, String? idValidUntil, String address, bool profileCompleted, int points, double pointsApproxRm, String qrCode
});




}
/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._self, this._then);

  final UserProfileModel _self;
  final $Res Function(UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? account = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? idType = null,Object? idNumber = null,Object? idValidUntil = freezed,Object? address = null,Object? profileCompleted = null,Object? points = null,Object? pointsApproxRm = null,Object? qrCode = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,idType: null == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,idValidUntil: freezed == idValidUntil ? _self.idValidUntil : idValidUntil // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,pointsApproxRm: null == pointsApproxRm ? _self.pointsApproxRm : pointsApproxRm // ignore: cast_nullable_to_non_nullable
as double,qrCode: null == qrCode ? _self.qrCode : qrCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileModel].
extension UserProfileModelPatterns on UserProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String account,  String email,  String firstName,  String lastName,  String idType,  String idNumber,  String? idValidUntil,  String address,  bool profileCompleted,  int points,  double pointsApproxRm,  String qrCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.userId,_that.account,_that.email,_that.firstName,_that.lastName,_that.idType,_that.idNumber,_that.idValidUntil,_that.address,_that.profileCompleted,_that.points,_that.pointsApproxRm,_that.qrCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String account,  String email,  String firstName,  String lastName,  String idType,  String idNumber,  String? idValidUntil,  String address,  bool profileCompleted,  int points,  double pointsApproxRm,  String qrCode)  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel():
return $default(_that.userId,_that.account,_that.email,_that.firstName,_that.lastName,_that.idType,_that.idNumber,_that.idValidUntil,_that.address,_that.profileCompleted,_that.points,_that.pointsApproxRm,_that.qrCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String account,  String email,  String firstName,  String lastName,  String idType,  String idNumber,  String? idValidUntil,  String address,  bool profileCompleted,  int points,  double pointsApproxRm,  String qrCode)?  $default,) {final _that = this;
switch (_that) {
case _UserProfileModel() when $default != null:
return $default(_that.userId,_that.account,_that.email,_that.firstName,_that.lastName,_that.idType,_that.idNumber,_that.idValidUntil,_that.address,_that.profileCompleted,_that.points,_that.pointsApproxRm,_that.qrCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfileModel extends UserProfileModel {
  const _UserProfileModel({this.userId = '', this.account = '', this.email = '', this.firstName = '', this.lastName = '', this.idType = 'id_card', this.idNumber = '', this.idValidUntil, this.address = '', this.profileCompleted = false, this.points = 0, this.pointsApproxRm = 0, this.qrCode = ''}): super._();
  factory _UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

@override@JsonKey() final  String userId;
@override@JsonKey() final  String account;
@override@JsonKey() final  String email;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override@JsonKey() final  String idType;
@override@JsonKey() final  String idNumber;
@override final  String? idValidUntil;
@override@JsonKey() final  String address;
@override@JsonKey() final  bool profileCompleted;
@override@JsonKey() final  int points;
@override@JsonKey() final  double pointsApproxRm;
@override@JsonKey() final  String qrCode;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileModelCopyWith<_UserProfileModel> get copyWith => __$UserProfileModelCopyWithImpl<_UserProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.account, account) || other.account == account)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber)&&(identical(other.idValidUntil, idValidUntil) || other.idValidUntil == idValidUntil)&&(identical(other.address, address) || other.address == address)&&(identical(other.profileCompleted, profileCompleted) || other.profileCompleted == profileCompleted)&&(identical(other.points, points) || other.points == points)&&(identical(other.pointsApproxRm, pointsApproxRm) || other.pointsApproxRm == pointsApproxRm)&&(identical(other.qrCode, qrCode) || other.qrCode == qrCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,account,email,firstName,lastName,idType,idNumber,idValidUntil,address,profileCompleted,points,pointsApproxRm,qrCode);

@override
String toString() {
  return 'UserProfileModel(userId: $userId, account: $account, email: $email, firstName: $firstName, lastName: $lastName, idType: $idType, idNumber: $idNumber, idValidUntil: $idValidUntil, address: $address, profileCompleted: $profileCompleted, points: $points, pointsApproxRm: $pointsApproxRm, qrCode: $qrCode)';
}


}

/// @nodoc
abstract mixin class _$UserProfileModelCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory _$UserProfileModelCopyWith(_UserProfileModel value, $Res Function(_UserProfileModel) _then) = __$UserProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String userId, String account, String email, String firstName, String lastName, String idType, String idNumber, String? idValidUntil, String address, bool profileCompleted, int points, double pointsApproxRm, String qrCode
});




}
/// @nodoc
class __$UserProfileModelCopyWithImpl<$Res>
    implements _$UserProfileModelCopyWith<$Res> {
  __$UserProfileModelCopyWithImpl(this._self, this._then);

  final _UserProfileModel _self;
  final $Res Function(_UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? account = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? idType = null,Object? idNumber = null,Object? idValidUntil = freezed,Object? address = null,Object? profileCompleted = null,Object? points = null,Object? pointsApproxRm = null,Object? qrCode = null,}) {
  return _then(_UserProfileModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,idType: null == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as String,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,idValidUntil: freezed == idValidUntil ? _self.idValidUntil : idValidUntil // ignore: cast_nullable_to_non_nullable
as String?,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,profileCompleted: null == profileCompleted ? _self.profileCompleted : profileCompleted // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,pointsApproxRm: null == pointsApproxRm ? _self.pointsApproxRm : pointsApproxRm // ignore: cast_nullable_to_non_nullable
as double,qrCode: null == qrCode ? _self.qrCode : qrCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
