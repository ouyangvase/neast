// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rent_property_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RentPropertyModel {

 int get id; String get name;@JsonKey(name: 'landlord_name') String get landlordName;
/// Create a copy of RentPropertyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RentPropertyModelCopyWith<RentPropertyModel> get copyWith => _$RentPropertyModelCopyWithImpl<RentPropertyModel>(this as RentPropertyModel, _$identity);

  /// Serializes this RentPropertyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RentPropertyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.landlordName, landlordName) || other.landlordName == landlordName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,landlordName);

@override
String toString() {
  return 'RentPropertyModel(id: $id, name: $name, landlordName: $landlordName)';
}


}

/// @nodoc
abstract mixin class $RentPropertyModelCopyWith<$Res>  {
  factory $RentPropertyModelCopyWith(RentPropertyModel value, $Res Function(RentPropertyModel) _then) = _$RentPropertyModelCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'landlord_name') String landlordName
});




}
/// @nodoc
class _$RentPropertyModelCopyWithImpl<$Res>
    implements $RentPropertyModelCopyWith<$Res> {
  _$RentPropertyModelCopyWithImpl(this._self, this._then);

  final RentPropertyModel _self;
  final $Res Function(RentPropertyModel) _then;

/// Create a copy of RentPropertyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? landlordName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,landlordName: null == landlordName ? _self.landlordName : landlordName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RentPropertyModel].
extension RentPropertyModelPatterns on RentPropertyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RentPropertyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RentPropertyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RentPropertyModel value)  $default,){
final _that = this;
switch (_that) {
case _RentPropertyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RentPropertyModel value)?  $default,){
final _that = this;
switch (_that) {
case _RentPropertyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'landlord_name')  String landlordName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RentPropertyModel() when $default != null:
return $default(_that.id,_that.name,_that.landlordName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'landlord_name')  String landlordName)  $default,) {final _that = this;
switch (_that) {
case _RentPropertyModel():
return $default(_that.id,_that.name,_that.landlordName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'landlord_name')  String landlordName)?  $default,) {final _that = this;
switch (_that) {
case _RentPropertyModel() when $default != null:
return $default(_that.id,_that.name,_that.landlordName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RentPropertyModel implements RentPropertyModel {
  const _RentPropertyModel({required this.id, this.name = '', @JsonKey(name: 'landlord_name') this.landlordName = ''});
  factory _RentPropertyModel.fromJson(Map<String, dynamic> json) => _$RentPropertyModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey(name: 'landlord_name') final  String landlordName;

/// Create a copy of RentPropertyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RentPropertyModelCopyWith<_RentPropertyModel> get copyWith => __$RentPropertyModelCopyWithImpl<_RentPropertyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RentPropertyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RentPropertyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.landlordName, landlordName) || other.landlordName == landlordName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,landlordName);

@override
String toString() {
  return 'RentPropertyModel(id: $id, name: $name, landlordName: $landlordName)';
}


}

/// @nodoc
abstract mixin class _$RentPropertyModelCopyWith<$Res> implements $RentPropertyModelCopyWith<$Res> {
  factory _$RentPropertyModelCopyWith(_RentPropertyModel value, $Res Function(_RentPropertyModel) _then) = __$RentPropertyModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'landlord_name') String landlordName
});




}
/// @nodoc
class __$RentPropertyModelCopyWithImpl<$Res>
    implements _$RentPropertyModelCopyWith<$Res> {
  __$RentPropertyModelCopyWithImpl(this._self, this._then);

  final _RentPropertyModel _self;
  final $Res Function(_RentPropertyModel) _then;

/// Create a copy of RentPropertyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? landlordName = null,}) {
  return _then(_RentPropertyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,landlordName: null == landlordName ? _self.landlordName : landlordName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
