// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_code_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CountryCodeModel {

 String get code;
/// Create a copy of CountryCodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryCodeModelCopyWith<CountryCodeModel> get copyWith => _$CountryCodeModelCopyWithImpl<CountryCodeModel>(this as CountryCodeModel, _$identity);

  /// Serializes this CountryCodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountryCodeModel&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'CountryCodeModel(code: $code)';
}


}

/// @nodoc
abstract mixin class $CountryCodeModelCopyWith<$Res>  {
  factory $CountryCodeModelCopyWith(CountryCodeModel value, $Res Function(CountryCodeModel) _then) = _$CountryCodeModelCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$CountryCodeModelCopyWithImpl<$Res>
    implements $CountryCodeModelCopyWith<$Res> {
  _$CountryCodeModelCopyWithImpl(this._self, this._then);

  final CountryCodeModel _self;
  final $Res Function(CountryCodeModel) _then;

/// Create a copy of CountryCodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CountryCodeModel].
extension CountryCodeModelPatterns on CountryCodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountryCodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountryCodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountryCodeModel value)  $default,){
final _that = this;
switch (_that) {
case _CountryCodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountryCodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _CountryCodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountryCodeModel() when $default != null:
return $default(_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code)  $default,) {final _that = this;
switch (_that) {
case _CountryCodeModel():
return $default(_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code)?  $default,) {final _that = this;
switch (_that) {
case _CountryCodeModel() when $default != null:
return $default(_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CountryCodeModel implements CountryCodeModel {
  const _CountryCodeModel({this.code = ''});
  factory _CountryCodeModel.fromJson(Map<String, dynamic> json) => _$CountryCodeModelFromJson(json);

@override@JsonKey() final  String code;

/// Create a copy of CountryCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryCodeModelCopyWith<_CountryCodeModel> get copyWith => __$CountryCodeModelCopyWithImpl<_CountryCodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountryCodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountryCodeModel&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'CountryCodeModel(code: $code)';
}


}

/// @nodoc
abstract mixin class _$CountryCodeModelCopyWith<$Res> implements $CountryCodeModelCopyWith<$Res> {
  factory _$CountryCodeModelCopyWith(_CountryCodeModel value, $Res Function(_CountryCodeModel) _then) = __$CountryCodeModelCopyWithImpl;
@override @useResult
$Res call({
 String code
});




}
/// @nodoc
class __$CountryCodeModelCopyWithImpl<$Res>
    implements _$CountryCodeModelCopyWith<$Res> {
  __$CountryCodeModelCopyWithImpl(this._self, this._then);

  final _CountryCodeModel _self;
  final $Res Function(_CountryCodeModel) _then;

/// Create a copy of CountryCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(_CountryCodeModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
