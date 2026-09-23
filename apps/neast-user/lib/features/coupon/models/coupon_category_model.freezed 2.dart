// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CouponCategoryModel {

 int get id; String get name;
/// Create a copy of CouponCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CouponCategoryModelCopyWith<CouponCategoryModel> get copyWith => _$CouponCategoryModelCopyWithImpl<CouponCategoryModel>(this as CouponCategoryModel, _$identity);

  /// Serializes this CouponCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CouponCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CouponCategoryModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $CouponCategoryModelCopyWith<$Res>  {
  factory $CouponCategoryModelCopyWith(CouponCategoryModel value, $Res Function(CouponCategoryModel) _then) = _$CouponCategoryModelCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$CouponCategoryModelCopyWithImpl<$Res>
    implements $CouponCategoryModelCopyWith<$Res> {
  _$CouponCategoryModelCopyWithImpl(this._self, this._then);

  final CouponCategoryModel _self;
  final $Res Function(CouponCategoryModel) _then;

/// Create a copy of CouponCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CouponCategoryModel].
extension CouponCategoryModelPatterns on CouponCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CouponCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CouponCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CouponCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _CouponCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CouponCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CouponCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CouponCategoryModel() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _CouponCategoryModel():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _CouponCategoryModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CouponCategoryModel implements CouponCategoryModel {
  const _CouponCategoryModel({required this.id, this.name = ''});
  factory _CouponCategoryModel.fromJson(Map<String, dynamic> json) => _$CouponCategoryModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;

/// Create a copy of CouponCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CouponCategoryModelCopyWith<_CouponCategoryModel> get copyWith => __$CouponCategoryModelCopyWithImpl<_CouponCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CouponCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CouponCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'CouponCategoryModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$CouponCategoryModelCopyWith<$Res> implements $CouponCategoryModelCopyWith<$Res> {
  factory _$CouponCategoryModelCopyWith(_CouponCategoryModel value, $Res Function(_CouponCategoryModel) _then) = __$CouponCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$CouponCategoryModelCopyWithImpl<$Res>
    implements _$CouponCategoryModelCopyWith<$Res> {
  __$CouponCategoryModelCopyWithImpl(this._self, this._then);

  final _CouponCategoryModel _self;
  final $Res Function(_CouponCategoryModel) _then;

/// Create a copy of CouponCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_CouponCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
