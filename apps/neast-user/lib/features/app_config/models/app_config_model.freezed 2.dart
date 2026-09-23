// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfigModel {

@JsonKey(name: 'show_alpha_notice') bool get showAlphaNotice;@JsonKey(name: 'payment_processing_fees') Map<String, double> get paymentProcessingFees;
/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigModelCopyWith<AppConfigModel> get copyWith => _$AppConfigModelCopyWithImpl<AppConfigModel>(this as AppConfigModel, _$identity);

  /// Serializes this AppConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfigModel&&(identical(other.showAlphaNotice, showAlphaNotice) || other.showAlphaNotice == showAlphaNotice)&&const DeepCollectionEquality().equals(other.paymentProcessingFees, paymentProcessingFees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showAlphaNotice,const DeepCollectionEquality().hash(paymentProcessingFees));

@override
String toString() {
  return 'AppConfigModel(showAlphaNotice: $showAlphaNotice, paymentProcessingFees: $paymentProcessingFees)';
}


}

/// @nodoc
abstract mixin class $AppConfigModelCopyWith<$Res>  {
  factory $AppConfigModelCopyWith(AppConfigModel value, $Res Function(AppConfigModel) _then) = _$AppConfigModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'show_alpha_notice') bool showAlphaNotice,@JsonKey(name: 'payment_processing_fees') Map<String, double> paymentProcessingFees
});




}
/// @nodoc
class _$AppConfigModelCopyWithImpl<$Res>
    implements $AppConfigModelCopyWith<$Res> {
  _$AppConfigModelCopyWithImpl(this._self, this._then);

  final AppConfigModel _self;
  final $Res Function(AppConfigModel) _then;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showAlphaNotice = null,Object? paymentProcessingFees = null,}) {
  return _then(_self.copyWith(
showAlphaNotice: null == showAlphaNotice ? _self.showAlphaNotice : showAlphaNotice // ignore: cast_nullable_to_non_nullable
as bool,paymentProcessingFees: null == paymentProcessingFees ? _self.paymentProcessingFees : paymentProcessingFees // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfigModel].
extension AppConfigModelPatterns on AppConfigModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _AppConfigModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'show_alpha_notice')  bool showAlphaNotice, @JsonKey(name: 'payment_processing_fees')  Map<String, double> paymentProcessingFees)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that.showAlphaNotice,_that.paymentProcessingFees);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'show_alpha_notice')  bool showAlphaNotice, @JsonKey(name: 'payment_processing_fees')  Map<String, double> paymentProcessingFees)  $default,) {final _that = this;
switch (_that) {
case _AppConfigModel():
return $default(_that.showAlphaNotice,_that.paymentProcessingFees);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'show_alpha_notice')  bool showAlphaNotice, @JsonKey(name: 'payment_processing_fees')  Map<String, double> paymentProcessingFees)?  $default,) {final _that = this;
switch (_that) {
case _AppConfigModel() when $default != null:
return $default(_that.showAlphaNotice,_that.paymentProcessingFees);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfigModel implements AppConfigModel {
  const _AppConfigModel({@JsonKey(name: 'show_alpha_notice') this.showAlphaNotice = false, @JsonKey(name: 'payment_processing_fees') final  Map<String, double> paymentProcessingFees = defaultPaymentProcessingFees}): _paymentProcessingFees = paymentProcessingFees;
  factory _AppConfigModel.fromJson(Map<String, dynamic> json) => _$AppConfigModelFromJson(json);

@override@JsonKey(name: 'show_alpha_notice') final  bool showAlphaNotice;
 final  Map<String, double> _paymentProcessingFees;
@override@JsonKey(name: 'payment_processing_fees') Map<String, double> get paymentProcessingFees {
  if (_paymentProcessingFees is EqualUnmodifiableMapView) return _paymentProcessingFees;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_paymentProcessingFees);
}


/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigModelCopyWith<_AppConfigModel> get copyWith => __$AppConfigModelCopyWithImpl<_AppConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfigModel&&(identical(other.showAlphaNotice, showAlphaNotice) || other.showAlphaNotice == showAlphaNotice)&&const DeepCollectionEquality().equals(other._paymentProcessingFees, _paymentProcessingFees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,showAlphaNotice,const DeepCollectionEquality().hash(_paymentProcessingFees));

@override
String toString() {
  return 'AppConfigModel(showAlphaNotice: $showAlphaNotice, paymentProcessingFees: $paymentProcessingFees)';
}


}

/// @nodoc
abstract mixin class _$AppConfigModelCopyWith<$Res> implements $AppConfigModelCopyWith<$Res> {
  factory _$AppConfigModelCopyWith(_AppConfigModel value, $Res Function(_AppConfigModel) _then) = __$AppConfigModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'show_alpha_notice') bool showAlphaNotice,@JsonKey(name: 'payment_processing_fees') Map<String, double> paymentProcessingFees
});




}
/// @nodoc
class __$AppConfigModelCopyWithImpl<$Res>
    implements _$AppConfigModelCopyWith<$Res> {
  __$AppConfigModelCopyWithImpl(this._self, this._then);

  final _AppConfigModel _self;
  final $Res Function(_AppConfigModel) _then;

/// Create a copy of AppConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showAlphaNotice = null,Object? paymentProcessingFees = null,}) {
  return _then(_AppConfigModel(
showAlphaNotice: null == showAlphaNotice ? _self.showAlphaNotice : showAlphaNotice // ignore: cast_nullable_to_non_nullable
as bool,paymentProcessingFees: null == paymentProcessingFees ? _self._paymentProcessingFees : paymentProcessingFees // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
