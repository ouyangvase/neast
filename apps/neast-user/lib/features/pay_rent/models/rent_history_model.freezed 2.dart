// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rent_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RentHistoryModel {

 int get id;@JsonKey(name: 'rent_id') int get rentId;@JsonKey(name: 'last_paid_date') String get lastPaidDate;@JsonKey(name: 'user_paid_at') String get userPaidAt; int get status;@JsonKey(name: 'display_status') String get displayStatus;@JsonKey(name: 'pay_status') String get payStatus;@JsonKey(fromJson: _amountFromJson) String get amount;@JsonKey(name: 'property_address') String get propertyAddress;@JsonKey(name: 'landlord_account_name') String get landlordAccountName;@JsonKey(name: 'payment_method') String get paymentMethod;@JsonKey(name: 'payment_no') String get paymentNo;@JsonKey(name: 'rental_period') String get rentalPeriod;
/// Create a copy of RentHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentHistoryModelCopyWith<RentHistoryModel> get copyWith => _$RentHistoryModelCopyWithImpl<RentHistoryModel>(this as RentHistoryModel, _$identity);

  /// Serializes this RentHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.rentId, rentId) || other.rentId == rentId)&&(identical(other.lastPaidDate, lastPaidDate) || other.lastPaidDate == lastPaidDate)&&(identical(other.userPaidAt, userPaidAt) || other.userPaidAt == userPaidAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.displayStatus, displayStatus) || other.displayStatus == displayStatus)&&(identical(other.payStatus, payStatus) || other.payStatus == payStatus)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.propertyAddress, propertyAddress) || other.propertyAddress == propertyAddress)&&(identical(other.landlordAccountName, landlordAccountName) || other.landlordAccountName == landlordAccountName)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentNo, paymentNo) || other.paymentNo == paymentNo)&&(identical(other.rentalPeriod, rentalPeriod) || other.rentalPeriod == rentalPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rentId,lastPaidDate,userPaidAt,status,displayStatus,payStatus,amount,propertyAddress,landlordAccountName,paymentMethod,paymentNo,rentalPeriod);

@override
String toString() {
  return 'RentHistoryModel(id: $id, rentId: $rentId, lastPaidDate: $lastPaidDate, userPaidAt: $userPaidAt, status: $status, displayStatus: $displayStatus, payStatus: $payStatus, amount: $amount, propertyAddress: $propertyAddress, landlordAccountName: $landlordAccountName, paymentMethod: $paymentMethod, paymentNo: $paymentNo, rentalPeriod: $rentalPeriod)';
}


}

/// @nodoc
abstract mixin class $RentHistoryModelCopyWith<$Res>  {
  factory $RentHistoryModelCopyWith(RentHistoryModel value, $Res Function(RentHistoryModel) _then) = _$RentHistoryModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'rent_id') int rentId,@JsonKey(name: 'last_paid_date') String lastPaidDate,@JsonKey(name: 'user_paid_at') String userPaidAt, int status,@JsonKey(name: 'display_status') String displayStatus,@JsonKey(name: 'pay_status') String payStatus,@JsonKey(fromJson: _amountFromJson) String amount,@JsonKey(name: 'property_address') String propertyAddress,@JsonKey(name: 'landlord_account_name') String landlordAccountName,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'payment_no') String paymentNo,@JsonKey(name: 'rental_period') String rentalPeriod
});




}
/// @nodoc
class _$RentHistoryModelCopyWithImpl<$Res>
    implements $RentHistoryModelCopyWith<$Res> {
  _$RentHistoryModelCopyWithImpl(this._self, this._then);

  final RentHistoryModel _self;
  final $Res Function(RentHistoryModel) _then;

/// Create a copy of RentHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rentId = null,Object? lastPaidDate = null,Object? userPaidAt = null,Object? status = null,Object? displayStatus = null,Object? payStatus = null,Object? amount = null,Object? propertyAddress = null,Object? landlordAccountName = null,Object? paymentMethod = null,Object? paymentNo = null,Object? rentalPeriod = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rentId: null == rentId ? _self.rentId : rentId // ignore: cast_nullable_to_non_nullable
as int,lastPaidDate: null == lastPaidDate ? _self.lastPaidDate : lastPaidDate // ignore: cast_nullable_to_non_nullable
as String,userPaidAt: null == userPaidAt ? _self.userPaidAt : userPaidAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as String,payStatus: null == payStatus ? _self.payStatus : payStatus // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,propertyAddress: null == propertyAddress ? _self.propertyAddress : propertyAddress // ignore: cast_nullable_to_non_nullable
as String,landlordAccountName: null == landlordAccountName ? _self.landlordAccountName : landlordAccountName // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentNo: null == paymentNo ? _self.paymentNo : paymentNo // ignore: cast_nullable_to_non_nullable
as String,rentalPeriod: null == rentalPeriod ? _self.rentalPeriod : rentalPeriod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RentHistoryModel].
extension RentHistoryModelPatterns on RentHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _RentHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _RentHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'rent_id')  int rentId, @JsonKey(name: 'last_paid_date')  String lastPaidDate, @JsonKey(name: 'user_paid_at')  String userPaidAt,  int status, @JsonKey(name: 'display_status')  String displayStatus, @JsonKey(name: 'pay_status')  String payStatus, @JsonKey(fromJson: _amountFromJson)  String amount, @JsonKey(name: 'property_address')  String propertyAddress, @JsonKey(name: 'landlord_account_name')  String landlordAccountName, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'payment_no')  String paymentNo, @JsonKey(name: 'rental_period')  String rentalPeriod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentHistoryModel() when $default != null:
return $default(_that.id,_that.rentId,_that.lastPaidDate,_that.userPaidAt,_that.status,_that.displayStatus,_that.payStatus,_that.amount,_that.propertyAddress,_that.landlordAccountName,_that.paymentMethod,_that.paymentNo,_that.rentalPeriod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'rent_id')  int rentId, @JsonKey(name: 'last_paid_date')  String lastPaidDate, @JsonKey(name: 'user_paid_at')  String userPaidAt,  int status, @JsonKey(name: 'display_status')  String displayStatus, @JsonKey(name: 'pay_status')  String payStatus, @JsonKey(fromJson: _amountFromJson)  String amount, @JsonKey(name: 'property_address')  String propertyAddress, @JsonKey(name: 'landlord_account_name')  String landlordAccountName, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'payment_no')  String paymentNo, @JsonKey(name: 'rental_period')  String rentalPeriod)  $default,) {final _that = this;
switch (_that) {
case _RentHistoryModel():
return $default(_that.id,_that.rentId,_that.lastPaidDate,_that.userPaidAt,_that.status,_that.displayStatus,_that.payStatus,_that.amount,_that.propertyAddress,_that.landlordAccountName,_that.paymentMethod,_that.paymentNo,_that.rentalPeriod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'rent_id')  int rentId, @JsonKey(name: 'last_paid_date')  String lastPaidDate, @JsonKey(name: 'user_paid_at')  String userPaidAt,  int status, @JsonKey(name: 'display_status')  String displayStatus, @JsonKey(name: 'pay_status')  String payStatus, @JsonKey(fromJson: _amountFromJson)  String amount, @JsonKey(name: 'property_address')  String propertyAddress, @JsonKey(name: 'landlord_account_name')  String landlordAccountName, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'payment_no')  String paymentNo, @JsonKey(name: 'rental_period')  String rentalPeriod)?  $default,) {final _that = this;
switch (_that) {
case _RentHistoryModel() when $default != null:
return $default(_that.id,_that.rentId,_that.lastPaidDate,_that.userPaidAt,_that.status,_that.displayStatus,_that.payStatus,_that.amount,_that.propertyAddress,_that.landlordAccountName,_that.paymentMethod,_that.paymentNo,_that.rentalPeriod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentHistoryModel extends RentHistoryModel {
  const _RentHistoryModel({required this.id, @JsonKey(name: 'rent_id') required this.rentId, @JsonKey(name: 'last_paid_date') this.lastPaidDate = '', @JsonKey(name: 'user_paid_at') this.userPaidAt = '', this.status = 0, @JsonKey(name: 'display_status') this.displayStatus = 'pending', @JsonKey(name: 'pay_status') this.payStatus = 'upcoming', @JsonKey(fromJson: _amountFromJson) this.amount = '0', @JsonKey(name: 'property_address') this.propertyAddress = '', @JsonKey(name: 'landlord_account_name') this.landlordAccountName = '', @JsonKey(name: 'payment_method') this.paymentMethod = '', @JsonKey(name: 'payment_no') this.paymentNo = '', @JsonKey(name: 'rental_period') this.rentalPeriod = ''}): super._();
  factory _RentHistoryModel.fromJson(Map<String, dynamic> json) => _$RentHistoryModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'rent_id') final  int rentId;
@override@JsonKey(name: 'last_paid_date') final  String lastPaidDate;
@override@JsonKey(name: 'user_paid_at') final  String userPaidAt;
@override@JsonKey() final  int status;
@override@JsonKey(name: 'display_status') final  String displayStatus;
@override@JsonKey(name: 'pay_status') final  String payStatus;
@override@JsonKey(fromJson: _amountFromJson) final  String amount;
@override@JsonKey(name: 'property_address') final  String propertyAddress;
@override@JsonKey(name: 'landlord_account_name') final  String landlordAccountName;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override@JsonKey(name: 'payment_no') final  String paymentNo;
@override@JsonKey(name: 'rental_period') final  String rentalPeriod;

/// Create a copy of RentHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentHistoryModelCopyWith<_RentHistoryModel> get copyWith => __$RentHistoryModelCopyWithImpl<_RentHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.rentId, rentId) || other.rentId == rentId)&&(identical(other.lastPaidDate, lastPaidDate) || other.lastPaidDate == lastPaidDate)&&(identical(other.userPaidAt, userPaidAt) || other.userPaidAt == userPaidAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.displayStatus, displayStatus) || other.displayStatus == displayStatus)&&(identical(other.payStatus, payStatus) || other.payStatus == payStatus)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.propertyAddress, propertyAddress) || other.propertyAddress == propertyAddress)&&(identical(other.landlordAccountName, landlordAccountName) || other.landlordAccountName == landlordAccountName)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentNo, paymentNo) || other.paymentNo == paymentNo)&&(identical(other.rentalPeriod, rentalPeriod) || other.rentalPeriod == rentalPeriod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,rentId,lastPaidDate,userPaidAt,status,displayStatus,payStatus,amount,propertyAddress,landlordAccountName,paymentMethod,paymentNo,rentalPeriod);

@override
String toString() {
  return 'RentHistoryModel(id: $id, rentId: $rentId, lastPaidDate: $lastPaidDate, userPaidAt: $userPaidAt, status: $status, displayStatus: $displayStatus, payStatus: $payStatus, amount: $amount, propertyAddress: $propertyAddress, landlordAccountName: $landlordAccountName, paymentMethod: $paymentMethod, paymentNo: $paymentNo, rentalPeriod: $rentalPeriod)';
}


}

/// @nodoc
abstract mixin class _$RentHistoryModelCopyWith<$Res> implements $RentHistoryModelCopyWith<$Res> {
  factory _$RentHistoryModelCopyWith(_RentHistoryModel value, $Res Function(_RentHistoryModel) _then) = __$RentHistoryModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'rent_id') int rentId,@JsonKey(name: 'last_paid_date') String lastPaidDate,@JsonKey(name: 'user_paid_at') String userPaidAt, int status,@JsonKey(name: 'display_status') String displayStatus,@JsonKey(name: 'pay_status') String payStatus,@JsonKey(fromJson: _amountFromJson) String amount,@JsonKey(name: 'property_address') String propertyAddress,@JsonKey(name: 'landlord_account_name') String landlordAccountName,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'payment_no') String paymentNo,@JsonKey(name: 'rental_period') String rentalPeriod
});




}
/// @nodoc
class __$RentHistoryModelCopyWithImpl<$Res>
    implements _$RentHistoryModelCopyWith<$Res> {
  __$RentHistoryModelCopyWithImpl(this._self, this._then);

  final _RentHistoryModel _self;
  final $Res Function(_RentHistoryModel) _then;

/// Create a copy of RentHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rentId = null,Object? lastPaidDate = null,Object? userPaidAt = null,Object? status = null,Object? displayStatus = null,Object? payStatus = null,Object? amount = null,Object? propertyAddress = null,Object? landlordAccountName = null,Object? paymentMethod = null,Object? paymentNo = null,Object? rentalPeriod = null,}) {
  return _then(_RentHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rentId: null == rentId ? _self.rentId : rentId // ignore: cast_nullable_to_non_nullable
as int,lastPaidDate: null == lastPaidDate ? _self.lastPaidDate : lastPaidDate // ignore: cast_nullable_to_non_nullable
as String,userPaidAt: null == userPaidAt ? _self.userPaidAt : userPaidAt // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as String,payStatus: null == payStatus ? _self.payStatus : payStatus // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,propertyAddress: null == propertyAddress ? _self.propertyAddress : propertyAddress // ignore: cast_nullable_to_non_nullable
as String,landlordAccountName: null == landlordAccountName ? _self.landlordAccountName : landlordAccountName // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,paymentNo: null == paymentNo ? _self.paymentNo : paymentNo // ignore: cast_nullable_to_non_nullable
as String,rentalPeriod: null == rentalPeriod ? _self.rentalPeriod : rentalPeriod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RentHistoryListResponse {

 List<RentHistoryModel> get items; int get total; int get page; int get limit;
/// Create a copy of RentHistoryListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentHistoryListResponseCopyWith<RentHistoryListResponse> get copyWith => _$RentHistoryListResponseCopyWithImpl<RentHistoryListResponse>(this as RentHistoryListResponse, _$identity);

  /// Serializes this RentHistoryListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentHistoryListResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,limit);

@override
String toString() {
  return 'RentHistoryListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $RentHistoryListResponseCopyWith<$Res>  {
  factory $RentHistoryListResponseCopyWith(RentHistoryListResponse value, $Res Function(RentHistoryListResponse) _then) = _$RentHistoryListResponseCopyWithImpl;
@useResult
$Res call({
 List<RentHistoryModel> items, int total, int page, int limit
});




}
/// @nodoc
class _$RentHistoryListResponseCopyWithImpl<$Res>
    implements $RentHistoryListResponseCopyWith<$Res> {
  _$RentHistoryListResponseCopyWithImpl(this._self, this._then);

  final RentHistoryListResponse _self;
  final $Res Function(RentHistoryListResponse) _then;

/// Create a copy of RentHistoryListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RentHistoryModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RentHistoryListResponse].
extension RentHistoryListResponsePatterns on RentHistoryListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentHistoryListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentHistoryListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentHistoryListResponse value)  $default,){
final _that = this;
switch (_that) {
case _RentHistoryListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentHistoryListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RentHistoryListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RentHistoryModel> items,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentHistoryListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RentHistoryModel> items,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _RentHistoryListResponse():
return $default(_that.items,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RentHistoryModel> items,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _RentHistoryListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentHistoryListResponse implements RentHistoryListResponse {
  const _RentHistoryListResponse({final  List<RentHistoryModel> items = const [], this.total = 0, this.page = 1, this.limit = 15}): _items = items;
  factory _RentHistoryListResponse.fromJson(Map<String, dynamic> json) => _$RentHistoryListResponseFromJson(json);

 final  List<RentHistoryModel> _items;
@override@JsonKey() List<RentHistoryModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of RentHistoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentHistoryListResponseCopyWith<_RentHistoryListResponse> get copyWith => __$RentHistoryListResponseCopyWithImpl<_RentHistoryListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentHistoryListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentHistoryListResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,limit);

@override
String toString() {
  return 'RentHistoryListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$RentHistoryListResponseCopyWith<$Res> implements $RentHistoryListResponseCopyWith<$Res> {
  factory _$RentHistoryListResponseCopyWith(_RentHistoryListResponse value, $Res Function(_RentHistoryListResponse) _then) = __$RentHistoryListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<RentHistoryModel> items, int total, int page, int limit
});




}
/// @nodoc
class __$RentHistoryListResponseCopyWithImpl<$Res>
    implements _$RentHistoryListResponseCopyWith<$Res> {
  __$RentHistoryListResponseCopyWithImpl(this._self, this._then);

  final _RentHistoryListResponse _self;
  final $Res Function(_RentHistoryListResponse) _then;

/// Create a copy of RentHistoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_RentHistoryListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RentHistoryModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RentPayOrder {

@JsonKey(name: 'order_id') String get orderId;@JsonKey(name: 'payment_url') String get paymentUrl;@JsonKey(name: 'history_id') int get historyId;
/// Create a copy of RentPayOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentPayOrderCopyWith<RentPayOrder> get copyWith => _$RentPayOrderCopyWithImpl<RentPayOrder>(this as RentPayOrder, _$identity);

  /// Serializes this RentPayOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentPayOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.historyId, historyId) || other.historyId == historyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,paymentUrl,historyId);

@override
String toString() {
  return 'RentPayOrder(orderId: $orderId, paymentUrl: $paymentUrl, historyId: $historyId)';
}


}

/// @nodoc
abstract mixin class $RentPayOrderCopyWith<$Res>  {
  factory $RentPayOrderCopyWith(RentPayOrder value, $Res Function(RentPayOrder) _then) = _$RentPayOrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'payment_url') String paymentUrl,@JsonKey(name: 'history_id') int historyId
});




}
/// @nodoc
class _$RentPayOrderCopyWithImpl<$Res>
    implements $RentPayOrderCopyWith<$Res> {
  _$RentPayOrderCopyWithImpl(this._self, this._then);

  final RentPayOrder _self;
  final $Res Function(RentPayOrder) _then;

/// Create a copy of RentPayOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? paymentUrl = null,Object? historyId = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: null == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String,historyId: null == historyId ? _self.historyId : historyId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RentPayOrder].
extension RentPayOrderPatterns on RentPayOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentPayOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentPayOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentPayOrder value)  $default,){
final _that = this;
switch (_that) {
case _RentPayOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentPayOrder value)?  $default,){
final _that = this;
switch (_that) {
case _RentPayOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'payment_url')  String paymentUrl, @JsonKey(name: 'history_id')  int historyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentPayOrder() when $default != null:
return $default(_that.orderId,_that.paymentUrl,_that.historyId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'payment_url')  String paymentUrl, @JsonKey(name: 'history_id')  int historyId)  $default,) {final _that = this;
switch (_that) {
case _RentPayOrder():
return $default(_that.orderId,_that.paymentUrl,_that.historyId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'payment_url')  String paymentUrl, @JsonKey(name: 'history_id')  int historyId)?  $default,) {final _that = this;
switch (_that) {
case _RentPayOrder() when $default != null:
return $default(_that.orderId,_that.paymentUrl,_that.historyId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentPayOrder implements RentPayOrder {
  const _RentPayOrder({@JsonKey(name: 'order_id') required this.orderId, @JsonKey(name: 'payment_url') this.paymentUrl = '', @JsonKey(name: 'history_id') required this.historyId});
  factory _RentPayOrder.fromJson(Map<String, dynamic> json) => _$RentPayOrderFromJson(json);

@override@JsonKey(name: 'order_id') final  String orderId;
@override@JsonKey(name: 'payment_url') final  String paymentUrl;
@override@JsonKey(name: 'history_id') final  int historyId;

/// Create a copy of RentPayOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentPayOrderCopyWith<_RentPayOrder> get copyWith => __$RentPayOrderCopyWithImpl<_RentPayOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentPayOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentPayOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.historyId, historyId) || other.historyId == historyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,paymentUrl,historyId);

@override
String toString() {
  return 'RentPayOrder(orderId: $orderId, paymentUrl: $paymentUrl, historyId: $historyId)';
}


}

/// @nodoc
abstract mixin class _$RentPayOrderCopyWith<$Res> implements $RentPayOrderCopyWith<$Res> {
  factory _$RentPayOrderCopyWith(_RentPayOrder value, $Res Function(_RentPayOrder) _then) = __$RentPayOrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'payment_url') String paymentUrl,@JsonKey(name: 'history_id') int historyId
});




}
/// @nodoc
class __$RentPayOrderCopyWithImpl<$Res>
    implements _$RentPayOrderCopyWith<$Res> {
  __$RentPayOrderCopyWithImpl(this._self, this._then);

  final _RentPayOrder _self;
  final $Res Function(_RentPayOrder) _then;

/// Create a copy of RentPayOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? paymentUrl = null,Object? historyId = null,}) {
  return _then(_RentPayOrder(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: null == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String,historyId: null == historyId ? _self.historyId : historyId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
