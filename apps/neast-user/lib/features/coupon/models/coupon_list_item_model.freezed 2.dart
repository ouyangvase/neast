// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CouponListItemModel {

 int get id;@JsonKey(name: 'user_coupon_id') int? get userCouponId; String get name;@JsonKey(name: 'required_points') int get requiredPoints;@JsonKey(name: 'valid_days') int get validDays;@JsonKey(name: 'category_id') int get categoryId;@JsonKey(name: 'category_name') String get categoryName; String get image;@JsonKey(name: 'usage_condition') String get usageCondition;@JsonKey(name: 'discount_amount') String get discountAmount;@JsonKey(name: 'merchant_names') List<String> get merchantNames;@JsonKey(name: 'expire_at') String? get expireAt;@JsonKey(name: 'redeemed_at') String? get redeemedAt;@JsonKey(name: 'voucher_status') MyVoucherStatus? get voucherStatus; String get sn; String get qrcode;@JsonKey(name: 'action_status') CouponActionStatus get actionStatus;
/// Create a copy of CouponListItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponListItemModelCopyWith<CouponListItemModel> get copyWith => _$CouponListItemModelCopyWithImpl<CouponListItemModel>(this as CouponListItemModel, _$identity);

  /// Serializes this CouponListItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userCouponId, userCouponId) || other.userCouponId == userCouponId)&&(identical(other.name, name) || other.name == name)&&(identical(other.requiredPoints, requiredPoints) || other.requiredPoints == requiredPoints)&&(identical(other.validDays, validDays) || other.validDays == validDays)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.image, image) || other.image == image)&&(identical(other.usageCondition, usageCondition) || other.usageCondition == usageCondition)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&const DeepCollectionEquality().equals(other.merchantNames, merchantNames)&&(identical(other.expireAt, expireAt) || other.expireAt == expireAt)&&(identical(other.redeemedAt, redeemedAt) || other.redeemedAt == redeemedAt)&&(identical(other.voucherStatus, voucherStatus) || other.voucherStatus == voucherStatus)&&(identical(other.sn, sn) || other.sn == sn)&&(identical(other.qrcode, qrcode) || other.qrcode == qrcode)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userCouponId,name,requiredPoints,validDays,categoryId,categoryName,image,usageCondition,discountAmount,const DeepCollectionEquality().hash(merchantNames),expireAt,redeemedAt,voucherStatus,sn,qrcode,actionStatus);

@override
String toString() {
  return 'CouponListItemModel(id: $id, userCouponId: $userCouponId, name: $name, requiredPoints: $requiredPoints, validDays: $validDays, categoryId: $categoryId, categoryName: $categoryName, image: $image, usageCondition: $usageCondition, discountAmount: $discountAmount, merchantNames: $merchantNames, expireAt: $expireAt, redeemedAt: $redeemedAt, voucherStatus: $voucherStatus, sn: $sn, qrcode: $qrcode, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class $CouponListItemModelCopyWith<$Res>  {
  factory $CouponListItemModelCopyWith(CouponListItemModel value, $Res Function(CouponListItemModel) _then) = _$CouponListItemModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_coupon_id') int? userCouponId, String name,@JsonKey(name: 'required_points') int requiredPoints,@JsonKey(name: 'valid_days') int validDays,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_name') String categoryName, String image,@JsonKey(name: 'usage_condition') String usageCondition,@JsonKey(name: 'discount_amount') String discountAmount,@JsonKey(name: 'merchant_names') List<String> merchantNames,@JsonKey(name: 'expire_at') String? expireAt,@JsonKey(name: 'redeemed_at') String? redeemedAt,@JsonKey(name: 'voucher_status') MyVoucherStatus? voucherStatus, String sn, String qrcode,@JsonKey(name: 'action_status') CouponActionStatus actionStatus
});




}
/// @nodoc
class _$CouponListItemModelCopyWithImpl<$Res>
    implements $CouponListItemModelCopyWith<$Res> {
  _$CouponListItemModelCopyWithImpl(this._self, this._then);

  final CouponListItemModel _self;
  final $Res Function(CouponListItemModel) _then;

/// Create a copy of CouponListItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userCouponId = freezed,Object? name = null,Object? requiredPoints = null,Object? validDays = null,Object? categoryId = null,Object? categoryName = null,Object? image = null,Object? usageCondition = null,Object? discountAmount = null,Object? merchantNames = null,Object? expireAt = freezed,Object? redeemedAt = freezed,Object? voucherStatus = freezed,Object? sn = null,Object? qrcode = null,Object? actionStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userCouponId: freezed == userCouponId ? _self.userCouponId : userCouponId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,requiredPoints: null == requiredPoints ? _self.requiredPoints : requiredPoints // ignore: cast_nullable_to_non_nullable
as int,validDays: null == validDays ? _self.validDays : validDays // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,usageCondition: null == usageCondition ? _self.usageCondition : usageCondition // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,merchantNames: null == merchantNames ? _self.merchantNames : merchantNames // ignore: cast_nullable_to_non_nullable
as List<String>,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as String?,redeemedAt: freezed == redeemedAt ? _self.redeemedAt : redeemedAt // ignore: cast_nullable_to_non_nullable
as String?,voucherStatus: freezed == voucherStatus ? _self.voucherStatus : voucherStatus // ignore: cast_nullable_to_non_nullable
as MyVoucherStatus?,sn: null == sn ? _self.sn : sn // ignore: cast_nullable_to_non_nullable
as String,qrcode: null == qrcode ? _self.qrcode : qrcode // ignore: cast_nullable_to_non_nullable
as String,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as CouponActionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponListItemModel].
extension CouponListItemModelPatterns on CouponListItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CouponListItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CouponListItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CouponListItemModel value)  $default,){
final _that = this;
switch (_that) {
case _CouponListItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CouponListItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _CouponListItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_coupon_id')  int? userCouponId,  String name, @JsonKey(name: 'required_points')  int requiredPoints, @JsonKey(name: 'valid_days')  int validDays, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_name')  String categoryName,  String image, @JsonKey(name: 'usage_condition')  String usageCondition, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'merchant_names')  List<String> merchantNames, @JsonKey(name: 'expire_at')  String? expireAt, @JsonKey(name: 'redeemed_at')  String? redeemedAt, @JsonKey(name: 'voucher_status')  MyVoucherStatus? voucherStatus,  String sn,  String qrcode, @JsonKey(name: 'action_status')  CouponActionStatus actionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CouponListItemModel() when $default != null:
return $default(_that.id,_that.userCouponId,_that.name,_that.requiredPoints,_that.validDays,_that.categoryId,_that.categoryName,_that.image,_that.usageCondition,_that.discountAmount,_that.merchantNames,_that.expireAt,_that.redeemedAt,_that.voucherStatus,_that.sn,_that.qrcode,_that.actionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_coupon_id')  int? userCouponId,  String name, @JsonKey(name: 'required_points')  int requiredPoints, @JsonKey(name: 'valid_days')  int validDays, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_name')  String categoryName,  String image, @JsonKey(name: 'usage_condition')  String usageCondition, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'merchant_names')  List<String> merchantNames, @JsonKey(name: 'expire_at')  String? expireAt, @JsonKey(name: 'redeemed_at')  String? redeemedAt, @JsonKey(name: 'voucher_status')  MyVoucherStatus? voucherStatus,  String sn,  String qrcode, @JsonKey(name: 'action_status')  CouponActionStatus actionStatus)  $default,) {final _that = this;
switch (_that) {
case _CouponListItemModel():
return $default(_that.id,_that.userCouponId,_that.name,_that.requiredPoints,_that.validDays,_that.categoryId,_that.categoryName,_that.image,_that.usageCondition,_that.discountAmount,_that.merchantNames,_that.expireAt,_that.redeemedAt,_that.voucherStatus,_that.sn,_that.qrcode,_that.actionStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_coupon_id')  int? userCouponId,  String name, @JsonKey(name: 'required_points')  int requiredPoints, @JsonKey(name: 'valid_days')  int validDays, @JsonKey(name: 'category_id')  int categoryId, @JsonKey(name: 'category_name')  String categoryName,  String image, @JsonKey(name: 'usage_condition')  String usageCondition, @JsonKey(name: 'discount_amount')  String discountAmount, @JsonKey(name: 'merchant_names')  List<String> merchantNames, @JsonKey(name: 'expire_at')  String? expireAt, @JsonKey(name: 'redeemed_at')  String? redeemedAt, @JsonKey(name: 'voucher_status')  MyVoucherStatus? voucherStatus,  String sn,  String qrcode, @JsonKey(name: 'action_status')  CouponActionStatus actionStatus)?  $default,) {final _that = this;
switch (_that) {
case _CouponListItemModel() when $default != null:
return $default(_that.id,_that.userCouponId,_that.name,_that.requiredPoints,_that.validDays,_that.categoryId,_that.categoryName,_that.image,_that.usageCondition,_that.discountAmount,_that.merchantNames,_that.expireAt,_that.redeemedAt,_that.voucherStatus,_that.sn,_that.qrcode,_that.actionStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CouponListItemModel extends CouponListItemModel {
  const _CouponListItemModel({required this.id, @JsonKey(name: 'user_coupon_id') this.userCouponId, this.name = '', @JsonKey(name: 'required_points') this.requiredPoints = 0, @JsonKey(name: 'valid_days') this.validDays = 0, @JsonKey(name: 'category_id') this.categoryId = 0, @JsonKey(name: 'category_name') this.categoryName = '', this.image = '', @JsonKey(name: 'usage_condition') this.usageCondition = '', @JsonKey(name: 'discount_amount') this.discountAmount = '0', @JsonKey(name: 'merchant_names') final  List<String> merchantNames = const [], @JsonKey(name: 'expire_at') this.expireAt, @JsonKey(name: 'redeemed_at') this.redeemedAt, @JsonKey(name: 'voucher_status') this.voucherStatus, this.sn = '', this.qrcode = '', @JsonKey(name: 'action_status') this.actionStatus = CouponActionStatus.redeem}): _merchantNames = merchantNames,super._();
  factory _CouponListItemModel.fromJson(Map<String, dynamic> json) => _$CouponListItemModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_coupon_id') final  int? userCouponId;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'required_points') final  int requiredPoints;
@override@JsonKey(name: 'valid_days') final  int validDays;
@override@JsonKey(name: 'category_id') final  int categoryId;
@override@JsonKey(name: 'category_name') final  String categoryName;
@override@JsonKey() final  String image;
@override@JsonKey(name: 'usage_condition') final  String usageCondition;
@override@JsonKey(name: 'discount_amount') final  String discountAmount;
 final  List<String> _merchantNames;
@override@JsonKey(name: 'merchant_names') List<String> get merchantNames {
  if (_merchantNames is EqualUnmodifiableListView) return _merchantNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_merchantNames);
}

@override@JsonKey(name: 'expire_at') final  String? expireAt;
@override@JsonKey(name: 'redeemed_at') final  String? redeemedAt;
@override@JsonKey(name: 'voucher_status') final  MyVoucherStatus? voucherStatus;
@override@JsonKey() final  String sn;
@override@JsonKey() final  String qrcode;
@override@JsonKey(name: 'action_status') final  CouponActionStatus actionStatus;

/// Create a copy of CouponListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponListItemModelCopyWith<_CouponListItemModel> get copyWith => __$CouponListItemModelCopyWithImpl<_CouponListItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouponListItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CouponListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userCouponId, userCouponId) || other.userCouponId == userCouponId)&&(identical(other.name, name) || other.name == name)&&(identical(other.requiredPoints, requiredPoints) || other.requiredPoints == requiredPoints)&&(identical(other.validDays, validDays) || other.validDays == validDays)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.image, image) || other.image == image)&&(identical(other.usageCondition, usageCondition) || other.usageCondition == usageCondition)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&const DeepCollectionEquality().equals(other._merchantNames, _merchantNames)&&(identical(other.expireAt, expireAt) || other.expireAt == expireAt)&&(identical(other.redeemedAt, redeemedAt) || other.redeemedAt == redeemedAt)&&(identical(other.voucherStatus, voucherStatus) || other.voucherStatus == voucherStatus)&&(identical(other.sn, sn) || other.sn == sn)&&(identical(other.qrcode, qrcode) || other.qrcode == qrcode)&&(identical(other.actionStatus, actionStatus) || other.actionStatus == actionStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userCouponId,name,requiredPoints,validDays,categoryId,categoryName,image,usageCondition,discountAmount,const DeepCollectionEquality().hash(_merchantNames),expireAt,redeemedAt,voucherStatus,sn,qrcode,actionStatus);

@override
String toString() {
  return 'CouponListItemModel(id: $id, userCouponId: $userCouponId, name: $name, requiredPoints: $requiredPoints, validDays: $validDays, categoryId: $categoryId, categoryName: $categoryName, image: $image, usageCondition: $usageCondition, discountAmount: $discountAmount, merchantNames: $merchantNames, expireAt: $expireAt, redeemedAt: $redeemedAt, voucherStatus: $voucherStatus, sn: $sn, qrcode: $qrcode, actionStatus: $actionStatus)';
}


}

/// @nodoc
abstract mixin class _$CouponListItemModelCopyWith<$Res> implements $CouponListItemModelCopyWith<$Res> {
  factory _$CouponListItemModelCopyWith(_CouponListItemModel value, $Res Function(_CouponListItemModel) _then) = __$CouponListItemModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_coupon_id') int? userCouponId, String name,@JsonKey(name: 'required_points') int requiredPoints,@JsonKey(name: 'valid_days') int validDays,@JsonKey(name: 'category_id') int categoryId,@JsonKey(name: 'category_name') String categoryName, String image,@JsonKey(name: 'usage_condition') String usageCondition,@JsonKey(name: 'discount_amount') String discountAmount,@JsonKey(name: 'merchant_names') List<String> merchantNames,@JsonKey(name: 'expire_at') String? expireAt,@JsonKey(name: 'redeemed_at') String? redeemedAt,@JsonKey(name: 'voucher_status') MyVoucherStatus? voucherStatus, String sn, String qrcode,@JsonKey(name: 'action_status') CouponActionStatus actionStatus
});




}
/// @nodoc
class __$CouponListItemModelCopyWithImpl<$Res>
    implements _$CouponListItemModelCopyWith<$Res> {
  __$CouponListItemModelCopyWithImpl(this._self, this._then);

  final _CouponListItemModel _self;
  final $Res Function(_CouponListItemModel) _then;

/// Create a copy of CouponListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userCouponId = freezed,Object? name = null,Object? requiredPoints = null,Object? validDays = null,Object? categoryId = null,Object? categoryName = null,Object? image = null,Object? usageCondition = null,Object? discountAmount = null,Object? merchantNames = null,Object? expireAt = freezed,Object? redeemedAt = freezed,Object? voucherStatus = freezed,Object? sn = null,Object? qrcode = null,Object? actionStatus = null,}) {
  return _then(_CouponListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userCouponId: freezed == userCouponId ? _self.userCouponId : userCouponId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,requiredPoints: null == requiredPoints ? _self.requiredPoints : requiredPoints // ignore: cast_nullable_to_non_nullable
as int,validDays: null == validDays ? _self.validDays : validDays // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,usageCondition: null == usageCondition ? _self.usageCondition : usageCondition // ignore: cast_nullable_to_non_nullable
as String,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as String,merchantNames: null == merchantNames ? _self._merchantNames : merchantNames // ignore: cast_nullable_to_non_nullable
as List<String>,expireAt: freezed == expireAt ? _self.expireAt : expireAt // ignore: cast_nullable_to_non_nullable
as String?,redeemedAt: freezed == redeemedAt ? _self.redeemedAt : redeemedAt // ignore: cast_nullable_to_non_nullable
as String?,voucherStatus: freezed == voucherStatus ? _self.voucherStatus : voucherStatus // ignore: cast_nullable_to_non_nullable
as MyVoucherStatus?,sn: null == sn ? _self.sn : sn // ignore: cast_nullable_to_non_nullable
as String,qrcode: null == qrcode ? _self.qrcode : qrcode // ignore: cast_nullable_to_non_nullable
as String,actionStatus: null == actionStatus ? _self.actionStatus : actionStatus // ignore: cast_nullable_to_non_nullable
as CouponActionStatus,
  ));
}


}

// dart format on
