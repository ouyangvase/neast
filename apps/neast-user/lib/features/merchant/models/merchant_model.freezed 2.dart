// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MerchantModel {

 int get id; String get name; String get address; String get image; double? get distance; double? get latitude; double? get longitude;@JsonKey(name: 'category_id') int? get categoryId;@JsonKey(name: 'nearest_merchant') MerchantModel? get nearestMerchant;
/// Create a copy of MerchantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantModelCopyWith<MerchantModel> get copyWith => _$MerchantModelCopyWithImpl<MerchantModel>(this as MerchantModel, _$identity);

  /// Serializes this MerchantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.image, image) || other.image == image)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.nearestMerchant, nearestMerchant) || other.nearestMerchant == nearestMerchant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,image,distance,latitude,longitude,categoryId,nearestMerchant);

@override
String toString() {
  return 'MerchantModel(id: $id, name: $name, address: $address, image: $image, distance: $distance, latitude: $latitude, longitude: $longitude, categoryId: $categoryId, nearestMerchant: $nearestMerchant)';
}


}

/// @nodoc
abstract mixin class $MerchantModelCopyWith<$Res>  {
  factory $MerchantModelCopyWith(MerchantModel value, $Res Function(MerchantModel) _then) = _$MerchantModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String address, String image, double? distance, double? latitude, double? longitude,@JsonKey(name: 'category_id') int? categoryId,@JsonKey(name: 'nearest_merchant') MerchantModel? nearestMerchant
});


$MerchantModelCopyWith<$Res>? get nearestMerchant;

}
/// @nodoc
class _$MerchantModelCopyWithImpl<$Res>
    implements $MerchantModelCopyWith<$Res> {
  _$MerchantModelCopyWithImpl(this._self, this._then);

  final MerchantModel _self;
  final $Res Function(MerchantModel) _then;

/// Create a copy of MerchantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? image = null,Object? distance = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? categoryId = freezed,Object? nearestMerchant = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,nearestMerchant: freezed == nearestMerchant ? _self.nearestMerchant : nearestMerchant // ignore: cast_nullable_to_non_nullable
as MerchantModel?,
  ));
}
/// Create a copy of MerchantModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MerchantModelCopyWith<$Res>? get nearestMerchant {
    if (_self.nearestMerchant == null) {
    return null;
  }

  return $MerchantModelCopyWith<$Res>(_self.nearestMerchant!, (value) {
    return _then(_self.copyWith(nearestMerchant: value));
  });
}
}


/// Adds pattern-matching-related methods to [MerchantModel].
extension MerchantModelPatterns on MerchantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantModel value)  $default,){
final _that = this;
switch (_that) {
case _MerchantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantModel value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String address,  String image,  double? distance,  double? latitude,  double? longitude, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'nearest_merchant')  MerchantModel? nearestMerchant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.image,_that.distance,_that.latitude,_that.longitude,_that.categoryId,_that.nearestMerchant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String address,  String image,  double? distance,  double? latitude,  double? longitude, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'nearest_merchant')  MerchantModel? nearestMerchant)  $default,) {final _that = this;
switch (_that) {
case _MerchantModel():
return $default(_that.id,_that.name,_that.address,_that.image,_that.distance,_that.latitude,_that.longitude,_that.categoryId,_that.nearestMerchant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String address,  String image,  double? distance,  double? latitude,  double? longitude, @JsonKey(name: 'category_id')  int? categoryId, @JsonKey(name: 'nearest_merchant')  MerchantModel? nearestMerchant)?  $default,) {final _that = this;
switch (_that) {
case _MerchantModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.image,_that.distance,_that.latitude,_that.longitude,_that.categoryId,_that.nearestMerchant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantModel extends MerchantModel {
  const _MerchantModel({required this.id, this.name = '', this.address = '', this.image = '', this.distance, this.latitude, this.longitude, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'nearest_merchant') this.nearestMerchant}): super._();
  factory _MerchantModel.fromJson(Map<String, dynamic> json) => _$MerchantModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String address;
@override@JsonKey() final  String image;
@override final  double? distance;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey(name: 'category_id') final  int? categoryId;
@override@JsonKey(name: 'nearest_merchant') final  MerchantModel? nearestMerchant;

/// Create a copy of MerchantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantModelCopyWith<_MerchantModel> get copyWith => __$MerchantModelCopyWithImpl<_MerchantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.image, image) || other.image == image)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.nearestMerchant, nearestMerchant) || other.nearestMerchant == nearestMerchant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,image,distance,latitude,longitude,categoryId,nearestMerchant);

@override
String toString() {
  return 'MerchantModel(id: $id, name: $name, address: $address, image: $image, distance: $distance, latitude: $latitude, longitude: $longitude, categoryId: $categoryId, nearestMerchant: $nearestMerchant)';
}


}

/// @nodoc
abstract mixin class _$MerchantModelCopyWith<$Res> implements $MerchantModelCopyWith<$Res> {
  factory _$MerchantModelCopyWith(_MerchantModel value, $Res Function(_MerchantModel) _then) = __$MerchantModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String address, String image, double? distance, double? latitude, double? longitude,@JsonKey(name: 'category_id') int? categoryId,@JsonKey(name: 'nearest_merchant') MerchantModel? nearestMerchant
});


@override $MerchantModelCopyWith<$Res>? get nearestMerchant;

}
/// @nodoc
class __$MerchantModelCopyWithImpl<$Res>
    implements _$MerchantModelCopyWith<$Res> {
  __$MerchantModelCopyWithImpl(this._self, this._then);

  final _MerchantModel _self;
  final $Res Function(_MerchantModel) _then;

/// Create a copy of MerchantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? image = null,Object? distance = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? categoryId = freezed,Object? nearestMerchant = freezed,}) {
  return _then(_MerchantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,nearestMerchant: freezed == nearestMerchant ? _self.nearestMerchant : nearestMerchant // ignore: cast_nullable_to_non_nullable
as MerchantModel?,
  ));
}

/// Create a copy of MerchantModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MerchantModelCopyWith<$Res>? get nearestMerchant {
    if (_self.nearestMerchant == null) {
    return null;
  }

  return $MerchantModelCopyWith<$Res>(_self.nearestMerchant!, (value) {
    return _then(_self.copyWith(nearestMerchant: value));
  });
}
}


/// @nodoc
mixin _$MerchantListResponse {

 List<MerchantModel> get items; int get total; int get page; int get limit;
/// Create a copy of MerchantListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MerchantListResponseCopyWith<MerchantListResponse> get copyWith => _$MerchantListResponseCopyWithImpl<MerchantListResponse>(this as MerchantListResponse, _$identity);

  /// Serializes this MerchantListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MerchantListResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,limit);

@override
String toString() {
  return 'MerchantListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $MerchantListResponseCopyWith<$Res>  {
  factory $MerchantListResponseCopyWith(MerchantListResponse value, $Res Function(MerchantListResponse) _then) = _$MerchantListResponseCopyWithImpl;
@useResult
$Res call({
 List<MerchantModel> items, int total, int page, int limit
});




}
/// @nodoc
class _$MerchantListResponseCopyWithImpl<$Res>
    implements $MerchantListResponseCopyWith<$Res> {
  _$MerchantListResponseCopyWithImpl(this._self, this._then);

  final MerchantListResponse _self;
  final $Res Function(MerchantListResponse) _then;

/// Create a copy of MerchantListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MerchantModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MerchantListResponse].
extension MerchantListResponsePatterns on MerchantListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MerchantListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MerchantListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MerchantListResponse value)  $default,){
final _that = this;
switch (_that) {
case _MerchantListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MerchantListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MerchantListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MerchantModel> items,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MerchantListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MerchantModel> items,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _MerchantListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MerchantModel> items,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _MerchantListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MerchantListResponse implements MerchantListResponse {
  const _MerchantListResponse({final  List<MerchantModel> items = const [], this.total = 0, this.page = 1, this.limit = 10}): _items = items;
  factory _MerchantListResponse.fromJson(Map<String, dynamic> json) => _$MerchantListResponseFromJson(json);

 final  List<MerchantModel> _items;
@override@JsonKey() List<MerchantModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of MerchantListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MerchantListResponseCopyWith<_MerchantListResponse> get copyWith => __$MerchantListResponseCopyWithImpl<_MerchantListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MerchantListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MerchantListResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,limit);

@override
String toString() {
  return 'MerchantListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$MerchantListResponseCopyWith<$Res> implements $MerchantListResponseCopyWith<$Res> {
  factory _$MerchantListResponseCopyWith(_MerchantListResponse value, $Res Function(_MerchantListResponse) _then) = __$MerchantListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<MerchantModel> items, int total, int page, int limit
});




}
/// @nodoc
class __$MerchantListResponseCopyWithImpl<$Res>
    implements _$MerchantListResponseCopyWith<$Res> {
  __$MerchantListResponseCopyWithImpl(this._self, this._then);

  final _MerchantListResponse _self;
  final $Res Function(_MerchantListResponse) _then;

/// Create a copy of MerchantListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_MerchantListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MerchantModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
