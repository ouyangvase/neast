// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MerchantCategoryModel {

 int get id; String get name;
/// Create a copy of MerchantCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantCategoryModelCopyWith<MerchantCategoryModel> get copyWith => _$MerchantCategoryModelCopyWithImpl<MerchantCategoryModel>(this as MerchantCategoryModel, _$identity);

  /// Serializes this MerchantCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MerchantCategoryModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MerchantCategoryModelCopyWith<$Res>  {
  factory $MerchantCategoryModelCopyWith(MerchantCategoryModel value, $Res Function(MerchantCategoryModel) _then) = _$MerchantCategoryModelCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$MerchantCategoryModelCopyWithImpl<$Res>
    implements $MerchantCategoryModelCopyWith<$Res> {
  _$MerchantCategoryModelCopyWithImpl(this._self, this._then);

  final MerchantCategoryModel _self;
  final $Res Function(MerchantCategoryModel) _then;

/// Create a copy of MerchantCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantCategoryModel].
extension MerchantCategoryModelPatterns on MerchantCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _MerchantCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantCategoryModel() when $default != null:
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
case _MerchantCategoryModel() when $default != null:
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
case _MerchantCategoryModel():
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
case _MerchantCategoryModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantCategoryModel implements MerchantCategoryModel {
  const _MerchantCategoryModel({required this.id, this.name = ''});
  factory _MerchantCategoryModel.fromJson(Map<String, dynamic> json) => _$MerchantCategoryModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;

/// Create a copy of MerchantCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantCategoryModelCopyWith<_MerchantCategoryModel> get copyWith => __$MerchantCategoryModelCopyWithImpl<_MerchantCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MerchantCategoryModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MerchantCategoryModelCopyWith<$Res> implements $MerchantCategoryModelCopyWith<$Res> {
  factory _$MerchantCategoryModelCopyWith(_MerchantCategoryModel value, $Res Function(_MerchantCategoryModel) _then) = __$MerchantCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$MerchantCategoryModelCopyWithImpl<$Res>
    implements _$MerchantCategoryModelCopyWith<$Res> {
  __$MerchantCategoryModelCopyWithImpl(this._self, this._then);

  final _MerchantCategoryModel _self;
  final $Res Function(_MerchantCategoryModel) _then;

/// Create a copy of MerchantCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_MerchantCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MerchantCategoryListResponse {

 List<MerchantCategoryModel> get items;
/// Create a copy of MerchantCategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantCategoryListResponseCopyWith<MerchantCategoryListResponse> get copyWith => _$MerchantCategoryListResponseCopyWithImpl<MerchantCategoryListResponse>(this as MerchantCategoryListResponse, _$identity);

  /// Serializes this MerchantCategoryListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantCategoryListResponse&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'MerchantCategoryListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class $MerchantCategoryListResponseCopyWith<$Res>  {
  factory $MerchantCategoryListResponseCopyWith(MerchantCategoryListResponse value, $Res Function(MerchantCategoryListResponse) _then) = _$MerchantCategoryListResponseCopyWithImpl;
@useResult
$Res call({
 List<MerchantCategoryModel> items
});




}
/// @nodoc
class _$MerchantCategoryListResponseCopyWithImpl<$Res>
    implements $MerchantCategoryListResponseCopyWith<$Res> {
  _$MerchantCategoryListResponseCopyWithImpl(this._self, this._then);

  final MerchantCategoryListResponse _self;
  final $Res Function(MerchantCategoryListResponse) _then;

/// Create a copy of MerchantCategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MerchantCategoryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantCategoryListResponse].
extension MerchantCategoryListResponsePatterns on MerchantCategoryListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantCategoryListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantCategoryListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantCategoryListResponse value)  $default,){
final _that = this;
switch (_that) {
case _MerchantCategoryListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantCategoryListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantCategoryListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MerchantCategoryModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantCategoryListResponse() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MerchantCategoryModel> items)  $default,) {final _that = this;
switch (_that) {
case _MerchantCategoryListResponse():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MerchantCategoryModel> items)?  $default,) {final _that = this;
switch (_that) {
case _MerchantCategoryListResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantCategoryListResponse implements MerchantCategoryListResponse {
  const _MerchantCategoryListResponse({final  List<MerchantCategoryModel> items = const []}): _items = items;
  factory _MerchantCategoryListResponse.fromJson(Map<String, dynamic> json) => _$MerchantCategoryListResponseFromJson(json);

 final  List<MerchantCategoryModel> _items;
@override@JsonKey() List<MerchantCategoryModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MerchantCategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantCategoryListResponseCopyWith<_MerchantCategoryListResponse> get copyWith => __$MerchantCategoryListResponseCopyWithImpl<_MerchantCategoryListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantCategoryListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantCategoryListResponse&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'MerchantCategoryListResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$MerchantCategoryListResponseCopyWith<$Res> implements $MerchantCategoryListResponseCopyWith<$Res> {
  factory _$MerchantCategoryListResponseCopyWith(_MerchantCategoryListResponse value, $Res Function(_MerchantCategoryListResponse) _then) = __$MerchantCategoryListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<MerchantCategoryModel> items
});




}
/// @nodoc
class __$MerchantCategoryListResponseCopyWithImpl<$Res>
    implements _$MerchantCategoryListResponseCopyWith<$Res> {
  __$MerchantCategoryListResponseCopyWithImpl(this._self, this._then);

  final _MerchantCategoryListResponse _self;
  final $Res Function(_MerchantCategoryListResponse) _then;

/// Create a copy of MerchantCategoryListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_MerchantCategoryListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MerchantCategoryModel>,
  ));
}


}

// dart format on
