// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rent_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RentModel {

 int get id;@JsonKey(fromJson: _amountFromJson) String get amount; String get file;@JsonKey(name: 'file_url') String get fileUrl;@JsonKey(name: 'paid_at') int get paidAt;@JsonKey(name: 'first_pay_month') String get firstPayMonth;@JsonKey(name: 'lease_months') int get leaseMonths;@JsonKey(name: 'expire_date') String get expireDate; int get status;@JsonKey(name: 'landlord_id') int? get landlordId;@JsonKey(name: 'landlord_name') String get landlordName;@JsonKey(name: 'landlord_account_name') String get landlordAccountName;@JsonKey(name: 'property_name') String get propertyName;@JsonKey(name: 'earn_points') int get earnPoints;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'can_pay') bool get canPay;@JsonKey(name: 'due_text') String get dueText;@JsonKey(name: 'date_label') String get dateLabel;
/// Create a copy of RentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentModelCopyWith<RentModel> get copyWith => _$RentModelCopyWithImpl<RentModel>(this as RentModel, _$identity);

  /// Serializes this RentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.file, file) || other.file == file)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.firstPayMonth, firstPayMonth) || other.firstPayMonth == firstPayMonth)&&(identical(other.leaseMonths, leaseMonths) || other.leaseMonths == leaseMonths)&&(identical(other.expireDate, expireDate) || other.expireDate == expireDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.landlordId, landlordId) || other.landlordId == landlordId)&&(identical(other.landlordName, landlordName) || other.landlordName == landlordName)&&(identical(other.landlordAccountName, landlordAccountName) || other.landlordAccountName == landlordAccountName)&&(identical(other.propertyName, propertyName) || other.propertyName == propertyName)&&(identical(other.earnPoints, earnPoints) || other.earnPoints == earnPoints)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.canPay, canPay) || other.canPay == canPay)&&(identical(other.dueText, dueText) || other.dueText == dueText)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,file,fileUrl,paidAt,firstPayMonth,leaseMonths,expireDate,status,landlordId,landlordName,landlordAccountName,propertyName,earnPoints,createdAt,canPay,dueText,dateLabel);

@override
String toString() {
  return 'RentModel(id: $id, amount: $amount, file: $file, fileUrl: $fileUrl, paidAt: $paidAt, firstPayMonth: $firstPayMonth, leaseMonths: $leaseMonths, expireDate: $expireDate, status: $status, landlordId: $landlordId, landlordName: $landlordName, landlordAccountName: $landlordAccountName, propertyName: $propertyName, earnPoints: $earnPoints, createdAt: $createdAt, canPay: $canPay, dueText: $dueText, dateLabel: $dateLabel)';
}


}

/// @nodoc
abstract mixin class $RentModelCopyWith<$Res>  {
  factory $RentModelCopyWith(RentModel value, $Res Function(RentModel) _then) = _$RentModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(fromJson: _amountFromJson) String amount, String file,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'paid_at') int paidAt,@JsonKey(name: 'first_pay_month') String firstPayMonth,@JsonKey(name: 'lease_months') int leaseMonths,@JsonKey(name: 'expire_date') String expireDate, int status,@JsonKey(name: 'landlord_id') int? landlordId,@JsonKey(name: 'landlord_name') String landlordName,@JsonKey(name: 'landlord_account_name') String landlordAccountName,@JsonKey(name: 'property_name') String propertyName,@JsonKey(name: 'earn_points') int earnPoints,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'can_pay') bool canPay,@JsonKey(name: 'due_text') String dueText,@JsonKey(name: 'date_label') String dateLabel
});




}
/// @nodoc
class _$RentModelCopyWithImpl<$Res>
    implements $RentModelCopyWith<$Res> {
  _$RentModelCopyWithImpl(this._self, this._then);

  final RentModel _self;
  final $Res Function(RentModel) _then;

/// Create a copy of RentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? file = null,Object? fileUrl = null,Object? paidAt = null,Object? firstPayMonth = null,Object? leaseMonths = null,Object? expireDate = null,Object? status = null,Object? landlordId = freezed,Object? landlordName = null,Object? landlordAccountName = null,Object? propertyName = null,Object? earnPoints = null,Object? createdAt = null,Object? canPay = null,Object? dueText = null,Object? dateLabel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as int,firstPayMonth: null == firstPayMonth ? _self.firstPayMonth : firstPayMonth // ignore: cast_nullable_to_non_nullable
as String,leaseMonths: null == leaseMonths ? _self.leaseMonths : leaseMonths // ignore: cast_nullable_to_non_nullable
as int,expireDate: null == expireDate ? _self.expireDate : expireDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,landlordId: freezed == landlordId ? _self.landlordId : landlordId // ignore: cast_nullable_to_non_nullable
as int?,landlordName: null == landlordName ? _self.landlordName : landlordName // ignore: cast_nullable_to_non_nullable
as String,landlordAccountName: null == landlordAccountName ? _self.landlordAccountName : landlordAccountName // ignore: cast_nullable_to_non_nullable
as String,propertyName: null == propertyName ? _self.propertyName : propertyName // ignore: cast_nullable_to_non_nullable
as String,earnPoints: null == earnPoints ? _self.earnPoints : earnPoints // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,canPay: null == canPay ? _self.canPay : canPay // ignore: cast_nullable_to_non_nullable
as bool,dueText: null == dueText ? _self.dueText : dueText // ignore: cast_nullable_to_non_nullable
as String,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RentModel].
extension RentModelPatterns on RentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentModel value)  $default,){
final _that = this;
switch (_that) {
case _RentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentModel value)?  $default,){
final _that = this;
switch (_that) {
case _RentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(fromJson: _amountFromJson)  String amount,  String file, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'paid_at')  int paidAt, @JsonKey(name: 'first_pay_month')  String firstPayMonth, @JsonKey(name: 'lease_months')  int leaseMonths, @JsonKey(name: 'expire_date')  String expireDate,  int status, @JsonKey(name: 'landlord_id')  int? landlordId, @JsonKey(name: 'landlord_name')  String landlordName, @JsonKey(name: 'landlord_account_name')  String landlordAccountName, @JsonKey(name: 'property_name')  String propertyName, @JsonKey(name: 'earn_points')  int earnPoints, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'can_pay')  bool canPay, @JsonKey(name: 'due_text')  String dueText, @JsonKey(name: 'date_label')  String dateLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentModel() when $default != null:
return $default(_that.id,_that.amount,_that.file,_that.fileUrl,_that.paidAt,_that.firstPayMonth,_that.leaseMonths,_that.expireDate,_that.status,_that.landlordId,_that.landlordName,_that.landlordAccountName,_that.propertyName,_that.earnPoints,_that.createdAt,_that.canPay,_that.dueText,_that.dateLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(fromJson: _amountFromJson)  String amount,  String file, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'paid_at')  int paidAt, @JsonKey(name: 'first_pay_month')  String firstPayMonth, @JsonKey(name: 'lease_months')  int leaseMonths, @JsonKey(name: 'expire_date')  String expireDate,  int status, @JsonKey(name: 'landlord_id')  int? landlordId, @JsonKey(name: 'landlord_name')  String landlordName, @JsonKey(name: 'landlord_account_name')  String landlordAccountName, @JsonKey(name: 'property_name')  String propertyName, @JsonKey(name: 'earn_points')  int earnPoints, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'can_pay')  bool canPay, @JsonKey(name: 'due_text')  String dueText, @JsonKey(name: 'date_label')  String dateLabel)  $default,) {final _that = this;
switch (_that) {
case _RentModel():
return $default(_that.id,_that.amount,_that.file,_that.fileUrl,_that.paidAt,_that.firstPayMonth,_that.leaseMonths,_that.expireDate,_that.status,_that.landlordId,_that.landlordName,_that.landlordAccountName,_that.propertyName,_that.earnPoints,_that.createdAt,_that.canPay,_that.dueText,_that.dateLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(fromJson: _amountFromJson)  String amount,  String file, @JsonKey(name: 'file_url')  String fileUrl, @JsonKey(name: 'paid_at')  int paidAt, @JsonKey(name: 'first_pay_month')  String firstPayMonth, @JsonKey(name: 'lease_months')  int leaseMonths, @JsonKey(name: 'expire_date')  String expireDate,  int status, @JsonKey(name: 'landlord_id')  int? landlordId, @JsonKey(name: 'landlord_name')  String landlordName, @JsonKey(name: 'landlord_account_name')  String landlordAccountName, @JsonKey(name: 'property_name')  String propertyName, @JsonKey(name: 'earn_points')  int earnPoints, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'can_pay')  bool canPay, @JsonKey(name: 'due_text')  String dueText, @JsonKey(name: 'date_label')  String dateLabel)?  $default,) {final _that = this;
switch (_that) {
case _RentModel() when $default != null:
return $default(_that.id,_that.amount,_that.file,_that.fileUrl,_that.paidAt,_that.firstPayMonth,_that.leaseMonths,_that.expireDate,_that.status,_that.landlordId,_that.landlordName,_that.landlordAccountName,_that.propertyName,_that.earnPoints,_that.createdAt,_that.canPay,_that.dueText,_that.dateLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentModel extends RentModel {
  const _RentModel({required this.id, @JsonKey(fromJson: _amountFromJson) this.amount = '0', this.file = '', @JsonKey(name: 'file_url') this.fileUrl = '', @JsonKey(name: 'paid_at') this.paidAt = 1, @JsonKey(name: 'first_pay_month') this.firstPayMonth = '', @JsonKey(name: 'lease_months') this.leaseMonths = 0, @JsonKey(name: 'expire_date') this.expireDate = '', this.status = 0, @JsonKey(name: 'landlord_id') this.landlordId, @JsonKey(name: 'landlord_name') this.landlordName = '', @JsonKey(name: 'landlord_account_name') this.landlordAccountName = '', @JsonKey(name: 'property_name') this.propertyName = '', @JsonKey(name: 'earn_points') this.earnPoints = 0, @JsonKey(name: 'created_at') this.createdAt = '', @JsonKey(name: 'can_pay') this.canPay = false, @JsonKey(name: 'due_text') this.dueText = '', @JsonKey(name: 'date_label') this.dateLabel = ''}): super._();
  factory _RentModel.fromJson(Map<String, dynamic> json) => _$RentModelFromJson(json);

@override final  int id;
@override@JsonKey(fromJson: _amountFromJson) final  String amount;
@override@JsonKey() final  String file;
@override@JsonKey(name: 'file_url') final  String fileUrl;
@override@JsonKey(name: 'paid_at') final  int paidAt;
@override@JsonKey(name: 'first_pay_month') final  String firstPayMonth;
@override@JsonKey(name: 'lease_months') final  int leaseMonths;
@override@JsonKey(name: 'expire_date') final  String expireDate;
@override@JsonKey() final  int status;
@override@JsonKey(name: 'landlord_id') final  int? landlordId;
@override@JsonKey(name: 'landlord_name') final  String landlordName;
@override@JsonKey(name: 'landlord_account_name') final  String landlordAccountName;
@override@JsonKey(name: 'property_name') final  String propertyName;
@override@JsonKey(name: 'earn_points') final  int earnPoints;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'can_pay') final  bool canPay;
@override@JsonKey(name: 'due_text') final  String dueText;
@override@JsonKey(name: 'date_label') final  String dateLabel;

/// Create a copy of RentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentModelCopyWith<_RentModel> get copyWith => __$RentModelCopyWithImpl<_RentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.file, file) || other.file == file)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.firstPayMonth, firstPayMonth) || other.firstPayMonth == firstPayMonth)&&(identical(other.leaseMonths, leaseMonths) || other.leaseMonths == leaseMonths)&&(identical(other.expireDate, expireDate) || other.expireDate == expireDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.landlordId, landlordId) || other.landlordId == landlordId)&&(identical(other.landlordName, landlordName) || other.landlordName == landlordName)&&(identical(other.landlordAccountName, landlordAccountName) || other.landlordAccountName == landlordAccountName)&&(identical(other.propertyName, propertyName) || other.propertyName == propertyName)&&(identical(other.earnPoints, earnPoints) || other.earnPoints == earnPoints)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.canPay, canPay) || other.canPay == canPay)&&(identical(other.dueText, dueText) || other.dueText == dueText)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,file,fileUrl,paidAt,firstPayMonth,leaseMonths,expireDate,status,landlordId,landlordName,landlordAccountName,propertyName,earnPoints,createdAt,canPay,dueText,dateLabel);

@override
String toString() {
  return 'RentModel(id: $id, amount: $amount, file: $file, fileUrl: $fileUrl, paidAt: $paidAt, firstPayMonth: $firstPayMonth, leaseMonths: $leaseMonths, expireDate: $expireDate, status: $status, landlordId: $landlordId, landlordName: $landlordName, landlordAccountName: $landlordAccountName, propertyName: $propertyName, earnPoints: $earnPoints, createdAt: $createdAt, canPay: $canPay, dueText: $dueText, dateLabel: $dateLabel)';
}


}

/// @nodoc
abstract mixin class _$RentModelCopyWith<$Res> implements $RentModelCopyWith<$Res> {
  factory _$RentModelCopyWith(_RentModel value, $Res Function(_RentModel) _then) = __$RentModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(fromJson: _amountFromJson) String amount, String file,@JsonKey(name: 'file_url') String fileUrl,@JsonKey(name: 'paid_at') int paidAt,@JsonKey(name: 'first_pay_month') String firstPayMonth,@JsonKey(name: 'lease_months') int leaseMonths,@JsonKey(name: 'expire_date') String expireDate, int status,@JsonKey(name: 'landlord_id') int? landlordId,@JsonKey(name: 'landlord_name') String landlordName,@JsonKey(name: 'landlord_account_name') String landlordAccountName,@JsonKey(name: 'property_name') String propertyName,@JsonKey(name: 'earn_points') int earnPoints,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'can_pay') bool canPay,@JsonKey(name: 'due_text') String dueText,@JsonKey(name: 'date_label') String dateLabel
});




}
/// @nodoc
class __$RentModelCopyWithImpl<$Res>
    implements _$RentModelCopyWith<$Res> {
  __$RentModelCopyWithImpl(this._self, this._then);

  final _RentModel _self;
  final $Res Function(_RentModel) _then;

/// Create a copy of RentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? file = null,Object? fileUrl = null,Object? paidAt = null,Object? firstPayMonth = null,Object? leaseMonths = null,Object? expireDate = null,Object? status = null,Object? landlordId = freezed,Object? landlordName = null,Object? landlordAccountName = null,Object? propertyName = null,Object? earnPoints = null,Object? createdAt = null,Object? canPay = null,Object? dueText = null,Object? dateLabel = null,}) {
  return _then(_RentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as int,firstPayMonth: null == firstPayMonth ? _self.firstPayMonth : firstPayMonth // ignore: cast_nullable_to_non_nullable
as String,leaseMonths: null == leaseMonths ? _self.leaseMonths : leaseMonths // ignore: cast_nullable_to_non_nullable
as int,expireDate: null == expireDate ? _self.expireDate : expireDate // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,landlordId: freezed == landlordId ? _self.landlordId : landlordId // ignore: cast_nullable_to_non_nullable
as int?,landlordName: null == landlordName ? _self.landlordName : landlordName // ignore: cast_nullable_to_non_nullable
as String,landlordAccountName: null == landlordAccountName ? _self.landlordAccountName : landlordAccountName // ignore: cast_nullable_to_non_nullable
as String,propertyName: null == propertyName ? _self.propertyName : propertyName // ignore: cast_nullable_to_non_nullable
as String,earnPoints: null == earnPoints ? _self.earnPoints : earnPoints // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,canPay: null == canPay ? _self.canPay : canPay // ignore: cast_nullable_to_non_nullable
as bool,dueText: null == dueText ? _self.dueText : dueText // ignore: cast_nullable_to_non_nullable
as String,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RentListResponse {

 List<RentModel> get items; int get total; int get page; int get limit;@JsonKey(name: 'rent_points_multiplier') double get rentPointsMultiplier;
/// Create a copy of RentListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentListResponseCopyWith<RentListResponse> get copyWith => _$RentListResponseCopyWithImpl<RentListResponse>(this as RentListResponse, _$identity);

  /// Serializes this RentListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentListResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.rentPointsMultiplier, rentPointsMultiplier) || other.rentPointsMultiplier == rentPointsMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,limit,rentPointsMultiplier);

@override
String toString() {
  return 'RentListResponse(items: $items, total: $total, page: $page, limit: $limit, rentPointsMultiplier: $rentPointsMultiplier)';
}


}

/// @nodoc
abstract mixin class $RentListResponseCopyWith<$Res>  {
  factory $RentListResponseCopyWith(RentListResponse value, $Res Function(RentListResponse) _then) = _$RentListResponseCopyWithImpl;
@useResult
$Res call({
 List<RentModel> items, int total, int page, int limit,@JsonKey(name: 'rent_points_multiplier') double rentPointsMultiplier
});




}
/// @nodoc
class _$RentListResponseCopyWithImpl<$Res>
    implements $RentListResponseCopyWith<$Res> {
  _$RentListResponseCopyWithImpl(this._self, this._then);

  final RentListResponse _self;
  final $Res Function(RentListResponse) _then;

/// Create a copy of RentListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,Object? rentPointsMultiplier = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<RentModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,rentPointsMultiplier: null == rentPointsMultiplier ? _self.rentPointsMultiplier : rentPointsMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RentListResponse].
extension RentListResponsePatterns on RentListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentListResponse value)  $default,){
final _that = this;
switch (_that) {
case _RentListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RentListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RentModel> items,  int total,  int page,  int limit, @JsonKey(name: 'rent_points_multiplier')  double rentPointsMultiplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit,_that.rentPointsMultiplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RentModel> items,  int total,  int page,  int limit, @JsonKey(name: 'rent_points_multiplier')  double rentPointsMultiplier)  $default,) {final _that = this;
switch (_that) {
case _RentListResponse():
return $default(_that.items,_that.total,_that.page,_that.limit,_that.rentPointsMultiplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RentModel> items,  int total,  int page,  int limit, @JsonKey(name: 'rent_points_multiplier')  double rentPointsMultiplier)?  $default,) {final _that = this;
switch (_that) {
case _RentListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit,_that.rentPointsMultiplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentListResponse implements RentListResponse {
  const _RentListResponse({final  List<RentModel> items = const [], this.total = 0, this.page = 1, this.limit = 20, @JsonKey(name: 'rent_points_multiplier') this.rentPointsMultiplier = 1.0}): _items = items;
  factory _RentListResponse.fromJson(Map<String, dynamic> json) => _$RentListResponseFromJson(json);

 final  List<RentModel> _items;
@override@JsonKey() List<RentModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;
@override@JsonKey(name: 'rent_points_multiplier') final  double rentPointsMultiplier;

/// Create a copy of RentListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentListResponseCopyWith<_RentListResponse> get copyWith => __$RentListResponseCopyWithImpl<_RentListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentListResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.rentPointsMultiplier, rentPointsMultiplier) || other.rentPointsMultiplier == rentPointsMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,limit,rentPointsMultiplier);

@override
String toString() {
  return 'RentListResponse(items: $items, total: $total, page: $page, limit: $limit, rentPointsMultiplier: $rentPointsMultiplier)';
}


}

/// @nodoc
abstract mixin class _$RentListResponseCopyWith<$Res> implements $RentListResponseCopyWith<$Res> {
  factory _$RentListResponseCopyWith(_RentListResponse value, $Res Function(_RentListResponse) _then) = __$RentListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<RentModel> items, int total, int page, int limit,@JsonKey(name: 'rent_points_multiplier') double rentPointsMultiplier
});




}
/// @nodoc
class __$RentListResponseCopyWithImpl<$Res>
    implements _$RentListResponseCopyWith<$Res> {
  __$RentListResponseCopyWithImpl(this._self, this._then);

  final _RentListResponse _self;
  final $Res Function(_RentListResponse) _then;

/// Create a copy of RentListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,Object? rentPointsMultiplier = null,}) {
  return _then(_RentListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<RentModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,rentPointsMultiplier: null == rentPointsMultiplier ? _self.rentPointsMultiplier : rentPointsMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
