// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_topup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletTopupModel {

 int get id;@JsonKey(name: 'user_id') int get userId;@JsonKey(fromJson: _amountFromJson) String get amount;@JsonKey(name: 'payment_method') String get paymentMethod;@JsonKey(name: 'order_id') String get orderId;@JsonKey(fromJson: _statusFromJson) int get status;@JsonKey(name: 'txn_id') String get txnId; String get channel;@JsonKey(name: 'paid_at') String get paidAt;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of WalletTopupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTopupModelCopyWith<WalletTopupModel> get copyWith => _$WalletTopupModelCopyWithImpl<WalletTopupModel>(this as WalletTopupModel, _$identity);

  /// Serializes this WalletTopupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTopupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.txnId, txnId) || other.txnId == txnId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,paymentMethod,orderId,status,txnId,channel,paidAt,createdAt);

@override
String toString() {
  return 'WalletTopupModel(id: $id, userId: $userId, amount: $amount, paymentMethod: $paymentMethod, orderId: $orderId, status: $status, txnId: $txnId, channel: $channel, paidAt: $paidAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $WalletTopupModelCopyWith<$Res>  {
  factory $WalletTopupModelCopyWith(WalletTopupModel value, $Res Function(WalletTopupModel) _then) = _$WalletTopupModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(fromJson: _amountFromJson) String amount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'order_id') String orderId,@JsonKey(fromJson: _statusFromJson) int status,@JsonKey(name: 'txn_id') String txnId, String channel,@JsonKey(name: 'paid_at') String paidAt,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$WalletTopupModelCopyWithImpl<$Res>
    implements $WalletTopupModelCopyWith<$Res> {
  _$WalletTopupModelCopyWithImpl(this._self, this._then);

  final WalletTopupModel _self;
  final $Res Function(WalletTopupModel) _then;

/// Create a copy of WalletTopupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? paymentMethod = null,Object? orderId = null,Object? status = null,Object? txnId = null,Object? channel = null,Object? paidAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,txnId: null == txnId ? _self.txnId : txnId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTopupModel].
extension WalletTopupModelPatterns on WalletTopupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTopupModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTopupModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTopupModel value)  $default,){
final _that = this;
switch (_that) {
case _WalletTopupModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTopupModel value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTopupModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(fromJson: _amountFromJson)  String amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'order_id')  String orderId, @JsonKey(fromJson: _statusFromJson)  int status, @JsonKey(name: 'txn_id')  String txnId,  String channel, @JsonKey(name: 'paid_at')  String paidAt, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTopupModel() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.paymentMethod,_that.orderId,_that.status,_that.txnId,_that.channel,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(fromJson: _amountFromJson)  String amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'order_id')  String orderId, @JsonKey(fromJson: _statusFromJson)  int status, @JsonKey(name: 'txn_id')  String txnId,  String channel, @JsonKey(name: 'paid_at')  String paidAt, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _WalletTopupModel():
return $default(_that.id,_that.userId,_that.amount,_that.paymentMethod,_that.orderId,_that.status,_that.txnId,_that.channel,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId, @JsonKey(fromJson: _amountFromJson)  String amount, @JsonKey(name: 'payment_method')  String paymentMethod, @JsonKey(name: 'order_id')  String orderId, @JsonKey(fromJson: _statusFromJson)  int status, @JsonKey(name: 'txn_id')  String txnId,  String channel, @JsonKey(name: 'paid_at')  String paidAt, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _WalletTopupModel() when $default != null:
return $default(_that.id,_that.userId,_that.amount,_that.paymentMethod,_that.orderId,_that.status,_that.txnId,_that.channel,_that.paidAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletTopupModel extends WalletTopupModel {
  const _WalletTopupModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(fromJson: _amountFromJson) this.amount = '0', @JsonKey(name: 'payment_method') this.paymentMethod = '', @JsonKey(name: 'order_id') this.orderId = '', @JsonKey(fromJson: _statusFromJson) this.status = 0, @JsonKey(name: 'txn_id') this.txnId = '', this.channel = '', @JsonKey(name: 'paid_at') this.paidAt = '', @JsonKey(name: 'created_at') this.createdAt = ''}): super._();
  factory _WalletTopupModel.fromJson(Map<String, dynamic> json) => _$WalletTopupModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(fromJson: _amountFromJson) final  String amount;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override@JsonKey(name: 'order_id') final  String orderId;
@override@JsonKey(fromJson: _statusFromJson) final  int status;
@override@JsonKey(name: 'txn_id') final  String txnId;
@override@JsonKey() final  String channel;
@override@JsonKey(name: 'paid_at') final  String paidAt;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of WalletTopupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTopupModelCopyWith<_WalletTopupModel> get copyWith => __$WalletTopupModelCopyWithImpl<_WalletTopupModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletTopupModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTopupModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.status, status) || other.status == status)&&(identical(other.txnId, txnId) || other.txnId == txnId)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,amount,paymentMethod,orderId,status,txnId,channel,paidAt,createdAt);

@override
String toString() {
  return 'WalletTopupModel(id: $id, userId: $userId, amount: $amount, paymentMethod: $paymentMethod, orderId: $orderId, status: $status, txnId: $txnId, channel: $channel, paidAt: $paidAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$WalletTopupModelCopyWith<$Res> implements $WalletTopupModelCopyWith<$Res> {
  factory _$WalletTopupModelCopyWith(_WalletTopupModel value, $Res Function(_WalletTopupModel) _then) = __$WalletTopupModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId,@JsonKey(fromJson: _amountFromJson) String amount,@JsonKey(name: 'payment_method') String paymentMethod,@JsonKey(name: 'order_id') String orderId,@JsonKey(fromJson: _statusFromJson) int status,@JsonKey(name: 'txn_id') String txnId, String channel,@JsonKey(name: 'paid_at') String paidAt,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$WalletTopupModelCopyWithImpl<$Res>
    implements _$WalletTopupModelCopyWith<$Res> {
  __$WalletTopupModelCopyWithImpl(this._self, this._then);

  final _WalletTopupModel _self;
  final $Res Function(_WalletTopupModel) _then;

/// Create a copy of WalletTopupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? amount = null,Object? paymentMethod = null,Object? orderId = null,Object? status = null,Object? txnId = null,Object? channel = null,Object? paidAt = null,Object? createdAt = null,}) {
  return _then(_WalletTopupModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,txnId: null == txnId ? _self.txnId : txnId // ignore: cast_nullable_to_non_nullable
as String,channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WalletTopupListResponse {

 List<WalletTopupModel> get items; int get total; int get page; int get limit;
/// Create a copy of WalletTopupListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTopupListResponseCopyWith<WalletTopupListResponse> get copyWith => _$WalletTopupListResponseCopyWithImpl<WalletTopupListResponse>(this as WalletTopupListResponse, _$identity);

  /// Serializes this WalletTopupListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTopupListResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,limit);

@override
String toString() {
  return 'WalletTopupListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $WalletTopupListResponseCopyWith<$Res>  {
  factory $WalletTopupListResponseCopyWith(WalletTopupListResponse value, $Res Function(WalletTopupListResponse) _then) = _$WalletTopupListResponseCopyWithImpl;
@useResult
$Res call({
 List<WalletTopupModel> items, int total, int page, int limit
});




}
/// @nodoc
class _$WalletTopupListResponseCopyWithImpl<$Res>
    implements $WalletTopupListResponseCopyWith<$Res> {
  _$WalletTopupListResponseCopyWithImpl(this._self, this._then);

  final WalletTopupListResponse _self;
  final $Res Function(WalletTopupListResponse) _then;

/// Create a copy of WalletTopupListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WalletTopupModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTopupListResponse].
extension WalletTopupListResponsePatterns on WalletTopupListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTopupListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTopupListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTopupListResponse value)  $default,){
final _that = this;
switch (_that) {
case _WalletTopupListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTopupListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTopupListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WalletTopupModel> items,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTopupListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WalletTopupModel> items,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _WalletTopupListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WalletTopupModel> items,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _WalletTopupListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletTopupListResponse implements WalletTopupListResponse {
  const _WalletTopupListResponse({final  List<WalletTopupModel> items = const [], this.total = 0, this.page = 1, this.limit = 15}): _items = items;
  factory _WalletTopupListResponse.fromJson(Map<String, dynamic> json) => _$WalletTopupListResponseFromJson(json);

 final  List<WalletTopupModel> _items;
@override@JsonKey() List<WalletTopupModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of WalletTopupListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTopupListResponseCopyWith<_WalletTopupListResponse> get copyWith => __$WalletTopupListResponseCopyWithImpl<_WalletTopupListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletTopupListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTopupListResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,limit);

@override
String toString() {
  return 'WalletTopupListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$WalletTopupListResponseCopyWith<$Res> implements $WalletTopupListResponseCopyWith<$Res> {
  factory _$WalletTopupListResponseCopyWith(_WalletTopupListResponse value, $Res Function(_WalletTopupListResponse) _then) = __$WalletTopupListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<WalletTopupModel> items, int total, int page, int limit
});




}
/// @nodoc
class __$WalletTopupListResponseCopyWithImpl<$Res>
    implements _$WalletTopupListResponseCopyWith<$Res> {
  __$WalletTopupListResponseCopyWithImpl(this._self, this._then);

  final _WalletTopupListResponse _self;
  final $Res Function(_WalletTopupListResponse) _then;

/// Create a copy of WalletTopupListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_WalletTopupListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WalletTopupModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WalletTopupOrder {

@JsonKey(name: 'order_id') String get orderId;@JsonKey(name: 'payment_url') String get paymentUrl;
/// Create a copy of WalletTopupOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTopupOrderCopyWith<WalletTopupOrder> get copyWith => _$WalletTopupOrderCopyWithImpl<WalletTopupOrder>(this as WalletTopupOrder, _$identity);

  /// Serializes this WalletTopupOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTopupOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,paymentUrl);

@override
String toString() {
  return 'WalletTopupOrder(orderId: $orderId, paymentUrl: $paymentUrl)';
}


}

/// @nodoc
abstract mixin class $WalletTopupOrderCopyWith<$Res>  {
  factory $WalletTopupOrderCopyWith(WalletTopupOrder value, $Res Function(WalletTopupOrder) _then) = _$WalletTopupOrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'payment_url') String paymentUrl
});




}
/// @nodoc
class _$WalletTopupOrderCopyWithImpl<$Res>
    implements $WalletTopupOrderCopyWith<$Res> {
  _$WalletTopupOrderCopyWithImpl(this._self, this._then);

  final WalletTopupOrder _self;
  final $Res Function(WalletTopupOrder) _then;

/// Create a copy of WalletTopupOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? paymentUrl = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: null == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTopupOrder].
extension WalletTopupOrderPatterns on WalletTopupOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTopupOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTopupOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTopupOrder value)  $default,){
final _that = this;
switch (_that) {
case _WalletTopupOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTopupOrder value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTopupOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'payment_url')  String paymentUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTopupOrder() when $default != null:
return $default(_that.orderId,_that.paymentUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'payment_url')  String paymentUrl)  $default,) {final _that = this;
switch (_that) {
case _WalletTopupOrder():
return $default(_that.orderId,_that.paymentUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'payment_url')  String paymentUrl)?  $default,) {final _that = this;
switch (_that) {
case _WalletTopupOrder() when $default != null:
return $default(_that.orderId,_that.paymentUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletTopupOrder implements WalletTopupOrder {
  const _WalletTopupOrder({@JsonKey(name: 'order_id') required this.orderId, @JsonKey(name: 'payment_url') this.paymentUrl = ''});
  factory _WalletTopupOrder.fromJson(Map<String, dynamic> json) => _$WalletTopupOrderFromJson(json);

@override@JsonKey(name: 'order_id') final  String orderId;
@override@JsonKey(name: 'payment_url') final  String paymentUrl;

/// Create a copy of WalletTopupOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTopupOrderCopyWith<_WalletTopupOrder> get copyWith => __$WalletTopupOrderCopyWithImpl<_WalletTopupOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletTopupOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTopupOrder&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,paymentUrl);

@override
String toString() {
  return 'WalletTopupOrder(orderId: $orderId, paymentUrl: $paymentUrl)';
}


}

/// @nodoc
abstract mixin class _$WalletTopupOrderCopyWith<$Res> implements $WalletTopupOrderCopyWith<$Res> {
  factory _$WalletTopupOrderCopyWith(_WalletTopupOrder value, $Res Function(_WalletTopupOrder) _then) = __$WalletTopupOrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'payment_url') String paymentUrl
});




}
/// @nodoc
class __$WalletTopupOrderCopyWithImpl<$Res>
    implements _$WalletTopupOrderCopyWith<$Res> {
  __$WalletTopupOrderCopyWithImpl(this._self, this._then);

  final _WalletTopupOrder _self;
  final $Res Function(_WalletTopupOrder) _then;

/// Create a copy of WalletTopupOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? paymentUrl = null,}) {
  return _then(_WalletTopupOrder(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: null == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WalletTopupResult {

 String get balance; WalletTopupModel? get topup;
/// Create a copy of WalletTopupResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTopupResultCopyWith<WalletTopupResult> get copyWith => _$WalletTopupResultCopyWithImpl<WalletTopupResult>(this as WalletTopupResult, _$identity);

  /// Serializes this WalletTopupResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTopupResult&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.topup, topup) || other.topup == topup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,topup);

@override
String toString() {
  return 'WalletTopupResult(balance: $balance, topup: $topup)';
}


}

/// @nodoc
abstract mixin class $WalletTopupResultCopyWith<$Res>  {
  factory $WalletTopupResultCopyWith(WalletTopupResult value, $Res Function(WalletTopupResult) _then) = _$WalletTopupResultCopyWithImpl;
@useResult
$Res call({
 String balance, WalletTopupModel? topup
});


$WalletTopupModelCopyWith<$Res>? get topup;

}
/// @nodoc
class _$WalletTopupResultCopyWithImpl<$Res>
    implements $WalletTopupResultCopyWith<$Res> {
  _$WalletTopupResultCopyWithImpl(this._self, this._then);

  final WalletTopupResult _self;
  final $Res Function(WalletTopupResult) _then;

/// Create a copy of WalletTopupResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? topup = freezed,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,topup: freezed == topup ? _self.topup : topup // ignore: cast_nullable_to_non_nullable
as WalletTopupModel?,
  ));
}
/// Create a copy of WalletTopupResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletTopupModelCopyWith<$Res>? get topup {
    if (_self.topup == null) {
    return null;
  }

  return $WalletTopupModelCopyWith<$Res>(_self.topup!, (value) {
    return _then(_self.copyWith(topup: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletTopupResult].
extension WalletTopupResultPatterns on WalletTopupResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTopupResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTopupResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTopupResult value)  $default,){
final _that = this;
switch (_that) {
case _WalletTopupResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTopupResult value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTopupResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String balance,  WalletTopupModel? topup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTopupResult() when $default != null:
return $default(_that.balance,_that.topup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String balance,  WalletTopupModel? topup)  $default,) {final _that = this;
switch (_that) {
case _WalletTopupResult():
return $default(_that.balance,_that.topup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String balance,  WalletTopupModel? topup)?  $default,) {final _that = this;
switch (_that) {
case _WalletTopupResult() when $default != null:
return $default(_that.balance,_that.topup);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletTopupResult implements WalletTopupResult {
  const _WalletTopupResult({this.balance = '0.00', this.topup});
  factory _WalletTopupResult.fromJson(Map<String, dynamic> json) => _$WalletTopupResultFromJson(json);

@override@JsonKey() final  String balance;
@override final  WalletTopupModel? topup;

/// Create a copy of WalletTopupResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTopupResultCopyWith<_WalletTopupResult> get copyWith => __$WalletTopupResultCopyWithImpl<_WalletTopupResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletTopupResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTopupResult&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.topup, topup) || other.topup == topup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,topup);

@override
String toString() {
  return 'WalletTopupResult(balance: $balance, topup: $topup)';
}


}

/// @nodoc
abstract mixin class _$WalletTopupResultCopyWith<$Res> implements $WalletTopupResultCopyWith<$Res> {
  factory _$WalletTopupResultCopyWith(_WalletTopupResult value, $Res Function(_WalletTopupResult) _then) = __$WalletTopupResultCopyWithImpl;
@override @useResult
$Res call({
 String balance, WalletTopupModel? topup
});


@override $WalletTopupModelCopyWith<$Res>? get topup;

}
/// @nodoc
class __$WalletTopupResultCopyWithImpl<$Res>
    implements _$WalletTopupResultCopyWith<$Res> {
  __$WalletTopupResultCopyWithImpl(this._self, this._then);

  final _WalletTopupResult _self;
  final $Res Function(_WalletTopupResult) _then;

/// Create a copy of WalletTopupResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? topup = freezed,}) {
  return _then(_WalletTopupResult(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,topup: freezed == topup ? _self.topup : topup // ignore: cast_nullable_to_non_nullable
as WalletTopupModel?,
  ));
}

/// Create a copy of WalletTopupResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletTopupModelCopyWith<$Res>? get topup {
    if (_self.topup == null) {
    return null;
  }

  return $WalletTopupModelCopyWith<$Res>(_self.topup!, (value) {
    return _then(_self.copyWith(topup: value));
  });
}
}

// dart format on
