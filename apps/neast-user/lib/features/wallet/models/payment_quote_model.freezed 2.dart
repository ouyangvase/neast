// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_quote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentMethodQuoteModel {

@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson) double get feePercent;@JsonKey(name: 'total_amount', fromJson: _amountFromJson) String get totalAmount;
/// Create a copy of PaymentMethodQuoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodQuoteModelCopyWith<PaymentMethodQuoteModel> get copyWith => _$PaymentMethodQuoteModelCopyWithImpl<PaymentMethodQuoteModel>(this as PaymentMethodQuoteModel, _$identity);

  /// Serializes this PaymentMethodQuoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethodQuoteModel&&(identical(other.feePercent, feePercent) || other.feePercent == feePercent)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feePercent,totalAmount);

@override
String toString() {
  return 'PaymentMethodQuoteModel(feePercent: $feePercent, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class $PaymentMethodQuoteModelCopyWith<$Res>  {
  factory $PaymentMethodQuoteModelCopyWith(PaymentMethodQuoteModel value, $Res Function(PaymentMethodQuoteModel) _then) = _$PaymentMethodQuoteModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson) double feePercent,@JsonKey(name: 'total_amount', fromJson: _amountFromJson) String totalAmount
});




}
/// @nodoc
class _$PaymentMethodQuoteModelCopyWithImpl<$Res>
    implements $PaymentMethodQuoteModelCopyWith<$Res> {
  _$PaymentMethodQuoteModelCopyWithImpl(this._self, this._then);

  final PaymentMethodQuoteModel _self;
  final $Res Function(PaymentMethodQuoteModel) _then;

/// Create a copy of PaymentMethodQuoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feePercent = null,Object? totalAmount = null,}) {
  return _then(_self.copyWith(
feePercent: null == feePercent ? _self.feePercent : feePercent // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethodQuoteModel].
extension PaymentMethodQuoteModelPatterns on PaymentMethodQuoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethodQuoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethodQuoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethodQuoteModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodQuoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethodQuoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodQuoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson)  double feePercent, @JsonKey(name: 'total_amount', fromJson: _amountFromJson)  String totalAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethodQuoteModel() when $default != null:
return $default(_that.feePercent,_that.totalAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson)  double feePercent, @JsonKey(name: 'total_amount', fromJson: _amountFromJson)  String totalAmount)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodQuoteModel():
return $default(_that.feePercent,_that.totalAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson)  double feePercent, @JsonKey(name: 'total_amount', fromJson: _amountFromJson)  String totalAmount)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodQuoteModel() when $default != null:
return $default(_that.feePercent,_that.totalAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentMethodQuoteModel implements PaymentMethodQuoteModel {
  const _PaymentMethodQuoteModel({@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson) this.feePercent = 0, @JsonKey(name: 'total_amount', fromJson: _amountFromJson) this.totalAmount = '0.00'});
  factory _PaymentMethodQuoteModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodQuoteModelFromJson(json);

@override@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson) final  double feePercent;
@override@JsonKey(name: 'total_amount', fromJson: _amountFromJson) final  String totalAmount;

/// Create a copy of PaymentMethodQuoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodQuoteModelCopyWith<_PaymentMethodQuoteModel> get copyWith => __$PaymentMethodQuoteModelCopyWithImpl<_PaymentMethodQuoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentMethodQuoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethodQuoteModel&&(identical(other.feePercent, feePercent) || other.feePercent == feePercent)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feePercent,totalAmount);

@override
String toString() {
  return 'PaymentMethodQuoteModel(feePercent: $feePercent, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodQuoteModelCopyWith<$Res> implements $PaymentMethodQuoteModelCopyWith<$Res> {
  factory _$PaymentMethodQuoteModelCopyWith(_PaymentMethodQuoteModel value, $Res Function(_PaymentMethodQuoteModel) _then) = __$PaymentMethodQuoteModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'fee_percent', fromJson: _feePercentFromJson) double feePercent,@JsonKey(name: 'total_amount', fromJson: _amountFromJson) String totalAmount
});




}
/// @nodoc
class __$PaymentMethodQuoteModelCopyWithImpl<$Res>
    implements _$PaymentMethodQuoteModelCopyWith<$Res> {
  __$PaymentMethodQuoteModelCopyWithImpl(this._self, this._then);

  final _PaymentMethodQuoteModel _self;
  final $Res Function(_PaymentMethodQuoteModel) _then;

/// Create a copy of PaymentMethodQuoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feePercent = null,Object? totalAmount = null,}) {
  return _then(_PaymentMethodQuoteModel(
feePercent: null == feePercent ? _self.feePercent : feePercent // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PaymentQuoteModel {

@JsonKey(fromJson: _amountFromJson) String get amount; Map<String, PaymentMethodQuoteModel> get methods;
/// Create a copy of PaymentQuoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentQuoteModelCopyWith<PaymentQuoteModel> get copyWith => _$PaymentQuoteModelCopyWithImpl<PaymentQuoteModel>(this as PaymentQuoteModel, _$identity);

  /// Serializes this PaymentQuoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentQuoteModel&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other.methods, methods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,const DeepCollectionEquality().hash(methods));

@override
String toString() {
  return 'PaymentQuoteModel(amount: $amount, methods: $methods)';
}


}

/// @nodoc
abstract mixin class $PaymentQuoteModelCopyWith<$Res>  {
  factory $PaymentQuoteModelCopyWith(PaymentQuoteModel value, $Res Function(PaymentQuoteModel) _then) = _$PaymentQuoteModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _amountFromJson) String amount, Map<String, PaymentMethodQuoteModel> methods
});




}
/// @nodoc
class _$PaymentQuoteModelCopyWithImpl<$Res>
    implements $PaymentQuoteModelCopyWith<$Res> {
  _$PaymentQuoteModelCopyWithImpl(this._self, this._then);

  final PaymentQuoteModel _self;
  final $Res Function(PaymentQuoteModel) _then;

/// Create a copy of PaymentQuoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? methods = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,methods: null == methods ? _self.methods : methods // ignore: cast_nullable_to_non_nullable
as Map<String, PaymentMethodQuoteModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentQuoteModel].
extension PaymentQuoteModelPatterns on PaymentQuoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentQuoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentQuoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentQuoteModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentQuoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentQuoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentQuoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _amountFromJson)  String amount,  Map<String, PaymentMethodQuoteModel> methods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentQuoteModel() when $default != null:
return $default(_that.amount,_that.methods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _amountFromJson)  String amount,  Map<String, PaymentMethodQuoteModel> methods)  $default,) {final _that = this;
switch (_that) {
case _PaymentQuoteModel():
return $default(_that.amount,_that.methods);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _amountFromJson)  String amount,  Map<String, PaymentMethodQuoteModel> methods)?  $default,) {final _that = this;
switch (_that) {
case _PaymentQuoteModel() when $default != null:
return $default(_that.amount,_that.methods);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentQuoteModel extends PaymentQuoteModel {
  const _PaymentQuoteModel({@JsonKey(fromJson: _amountFromJson) this.amount = '0.00', final  Map<String, PaymentMethodQuoteModel> methods = const {}}): _methods = methods,super._();
  factory _PaymentQuoteModel.fromJson(Map<String, dynamic> json) => _$PaymentQuoteModelFromJson(json);

@override@JsonKey(fromJson: _amountFromJson) final  String amount;
 final  Map<String, PaymentMethodQuoteModel> _methods;
@override@JsonKey() Map<String, PaymentMethodQuoteModel> get methods {
  if (_methods is EqualUnmodifiableMapView) return _methods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_methods);
}


/// Create a copy of PaymentQuoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentQuoteModelCopyWith<_PaymentQuoteModel> get copyWith => __$PaymentQuoteModelCopyWithImpl<_PaymentQuoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentQuoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentQuoteModel&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other._methods, _methods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,const DeepCollectionEquality().hash(_methods));

@override
String toString() {
  return 'PaymentQuoteModel(amount: $amount, methods: $methods)';
}


}

/// @nodoc
abstract mixin class _$PaymentQuoteModelCopyWith<$Res> implements $PaymentQuoteModelCopyWith<$Res> {
  factory _$PaymentQuoteModelCopyWith(_PaymentQuoteModel value, $Res Function(_PaymentQuoteModel) _then) = __$PaymentQuoteModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _amountFromJson) String amount, Map<String, PaymentMethodQuoteModel> methods
});




}
/// @nodoc
class __$PaymentQuoteModelCopyWithImpl<$Res>
    implements _$PaymentQuoteModelCopyWith<$Res> {
  __$PaymentQuoteModelCopyWithImpl(this._self, this._then);

  final _PaymentQuoteModel _self;
  final $Res Function(_PaymentQuoteModel) _then;

/// Create a copy of PaymentQuoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? methods = null,}) {
  return _then(_PaymentQuoteModel(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,methods: null == methods ? _self._methods : methods // ignore: cast_nullable_to_non_nullable
as Map<String, PaymentMethodQuoteModel>,
  ));
}


}

// dart format on
