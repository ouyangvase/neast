// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'points_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointsLogModel {

 int get id;@JsonKey(name: 'user_id') int get userId; int get points; String get title; String get subtitle;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of PointsLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsLogModelCopyWith<PointsLogModel> get copyWith => _$PointsLogModelCopyWithImpl<PointsLogModel>(this as PointsLogModel, _$identity);

  /// Serializes this PointsLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.points, points) || other.points == points)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,points,title,subtitle,createdAt);

@override
String toString() {
  return 'PointsLogModel(id: $id, userId: $userId, points: $points, title: $title, subtitle: $subtitle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PointsLogModelCopyWith<$Res>  {
  factory $PointsLogModelCopyWith(PointsLogModel value, $Res Function(PointsLogModel) _then) = _$PointsLogModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, int points, String title, String subtitle,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$PointsLogModelCopyWithImpl<$Res>
    implements $PointsLogModelCopyWith<$Res> {
  _$PointsLogModelCopyWithImpl(this._self, this._then);

  final PointsLogModel _self;
  final $Res Function(PointsLogModel) _then;

/// Create a copy of PointsLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? points = null,Object? title = null,Object? subtitle = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PointsLogModel].
extension PointsLogModelPatterns on PointsLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsLogModel value)  $default,){
final _that = this;
switch (_that) {
case _PointsLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _PointsLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  int points,  String title,  String subtitle, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.points,_that.title,_that.subtitle,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  int userId,  int points,  String title,  String subtitle, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _PointsLogModel():
return $default(_that.id,_that.userId,_that.points,_that.title,_that.subtitle,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  int userId,  int points,  String title,  String subtitle, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PointsLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.points,_that.title,_that.subtitle,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsLogModel extends PointsLogModel {
  const _PointsLogModel({required this.id, @JsonKey(name: 'user_id') required this.userId, this.points = 0, this.title = '', this.subtitle = '', @JsonKey(name: 'created_at') this.createdAt = ''}): super._();
  factory _PointsLogModel.fromJson(Map<String, dynamic> json) => _$PointsLogModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey() final  int points;
@override@JsonKey() final  String title;
@override@JsonKey() final  String subtitle;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of PointsLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsLogModelCopyWith<_PointsLogModel> get copyWith => __$PointsLogModelCopyWithImpl<_PointsLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.points, points) || other.points == points)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,points,title,subtitle,createdAt);

@override
String toString() {
  return 'PointsLogModel(id: $id, userId: $userId, points: $points, title: $title, subtitle: $subtitle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PointsLogModelCopyWith<$Res> implements $PointsLogModelCopyWith<$Res> {
  factory _$PointsLogModelCopyWith(_PointsLogModel value, $Res Function(_PointsLogModel) _then) = __$PointsLogModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') int userId, int points, String title, String subtitle,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$PointsLogModelCopyWithImpl<$Res>
    implements _$PointsLogModelCopyWith<$Res> {
  __$PointsLogModelCopyWithImpl(this._self, this._then);

  final _PointsLogModel _self;
  final $Res Function(_PointsLogModel) _then;

/// Create a copy of PointsLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? points = null,Object? title = null,Object? subtitle = null,Object? createdAt = null,}) {
  return _then(_PointsLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PointsLogListResponse {

 List<PointsLogModel> get items; int get total; int get page; int get limit;
/// Create a copy of PointsLogListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsLogListResponseCopyWith<PointsLogListResponse> get copyWith => _$PointsLogListResponseCopyWithImpl<PointsLogListResponse>(this as PointsLogListResponse, _$identity);

  /// Serializes this PointsLogListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsLogListResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,limit);

@override
String toString() {
  return 'PointsLogListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $PointsLogListResponseCopyWith<$Res>  {
  factory $PointsLogListResponseCopyWith(PointsLogListResponse value, $Res Function(PointsLogListResponse) _then) = _$PointsLogListResponseCopyWithImpl;
@useResult
$Res call({
 List<PointsLogModel> items, int total, int page, int limit
});




}
/// @nodoc
class _$PointsLogListResponseCopyWithImpl<$Res>
    implements $PointsLogListResponseCopyWith<$Res> {
  _$PointsLogListResponseCopyWithImpl(this._self, this._then);

  final PointsLogListResponse _self;
  final $Res Function(PointsLogListResponse) _then;

/// Create a copy of PointsLogListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PointsLogModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PointsLogListResponse].
extension PointsLogListResponsePatterns on PointsLogListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsLogListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsLogListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsLogListResponse value)  $default,){
final _that = this;
switch (_that) {
case _PointsLogListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsLogListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PointsLogListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PointsLogModel> items,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsLogListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PointsLogModel> items,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _PointsLogListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PointsLogModel> items,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _PointsLogListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsLogListResponse implements PointsLogListResponse {
  const _PointsLogListResponse({final  List<PointsLogModel> items = const [], this.total = 0, this.page = 1, this.limit = 15}): _items = items;
  factory _PointsLogListResponse.fromJson(Map<String, dynamic> json) => _$PointsLogListResponseFromJson(json);

 final  List<PointsLogModel> _items;
@override@JsonKey() List<PointsLogModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of PointsLogListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsLogListResponseCopyWith<_PointsLogListResponse> get copyWith => __$PointsLogListResponseCopyWithImpl<_PointsLogListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsLogListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsLogListResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,limit);

@override
String toString() {
  return 'PointsLogListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$PointsLogListResponseCopyWith<$Res> implements $PointsLogListResponseCopyWith<$Res> {
  factory _$PointsLogListResponseCopyWith(_PointsLogListResponse value, $Res Function(_PointsLogListResponse) _then) = __$PointsLogListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<PointsLogModel> items, int total, int page, int limit
});




}
/// @nodoc
class __$PointsLogListResponseCopyWithImpl<$Res>
    implements _$PointsLogListResponseCopyWith<$Res> {
  __$PointsLogListResponseCopyWithImpl(this._self, this._then);

  final _PointsLogListResponse _self;
  final $Res Function(_PointsLogListResponse) _then;

/// Create a copy of PointsLogListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_PointsLogListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PointsLogModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
