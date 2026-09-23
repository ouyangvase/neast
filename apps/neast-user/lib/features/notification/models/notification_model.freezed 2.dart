// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {

 int get id; String get title; String get content;@JsonKey(name: 'is_read') int get isRead;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationModelCopyWith<NotificationModel> get copyWith => _$NotificationModelCopyWithImpl<NotificationModel>(this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,isRead,createdAt);

@override
String toString() {
  return 'NotificationModel(id: $id, title: $title, content: $content, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res>  {
  factory $NotificationModelCopyWith(NotificationModel value, $Res Function(NotificationModel) _then) = _$NotificationModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String content,@JsonKey(name: 'is_read') int isRead,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String content, @JsonKey(name: 'is_read')  int isRead, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String content, @JsonKey(name: 'is_read')  int isRead, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationModel():
return $default(_that.id,_that.title,_that.content,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String content, @JsonKey(name: 'is_read')  int isRead, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationModel extends NotificationModel {
  const _NotificationModel({required this.id, required this.title, required this.content, @JsonKey(name: 'is_read') this.isRead = 0, @JsonKey(name: 'created_at') this.createdAt = ''}): super._();
  factory _NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  String content;
@override@JsonKey(name: 'is_read') final  int isRead;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationModelCopyWith<_NotificationModel> get copyWith => __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,isRead,createdAt);

@override
String toString() {
  return 'NotificationModel(id: $id, title: $title, content: $content, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res> implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(_NotificationModel value, $Res Function(_NotificationModel) _then) = __$NotificationModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String content,@JsonKey(name: 'is_read') int isRead,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_NotificationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$NotificationListResponse {

 List<NotificationModel> get items; int get total; int get page; int get limit;
/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationListResponseCopyWith<NotificationListResponse> get copyWith => _$NotificationListResponseCopyWithImpl<NotificationListResponse>(this as NotificationListResponse, _$identity);

  /// Serializes this NotificationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationListResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,page,limit);

@override
String toString() {
  return 'NotificationListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $NotificationListResponseCopyWith<$Res>  {
  factory $NotificationListResponseCopyWith(NotificationListResponse value, $Res Function(NotificationListResponse) _then) = _$NotificationListResponseCopyWithImpl;
@useResult
$Res call({
 List<NotificationModel> items, int total, int page, int limit
});




}
/// @nodoc
class _$NotificationListResponseCopyWithImpl<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  _$NotificationListResponseCopyWithImpl(this._self, this._then);

  final NotificationListResponse _self;
  final $Res Function(NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationListResponse].
extension NotificationListResponsePatterns on NotificationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NotificationModel> items,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NotificationModel> items,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NotificationModel> items,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.items,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationListResponse implements NotificationListResponse {
  const _NotificationListResponse({final  List<NotificationModel> items = const [], this.total = 0, this.page = 1, this.limit = 15}): _items = items;
  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) => _$NotificationListResponseFromJson(json);

 final  List<NotificationModel> _items;
@override@JsonKey() List<NotificationModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationListResponseCopyWith<_NotificationListResponse> get copyWith => __$NotificationListResponseCopyWithImpl<_NotificationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationListResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,page,limit);

@override
String toString() {
  return 'NotificationListResponse(items: $items, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$NotificationListResponseCopyWith<$Res> implements $NotificationListResponseCopyWith<$Res> {
  factory _$NotificationListResponseCopyWith(_NotificationListResponse value, $Res Function(_NotificationListResponse) _then) = __$NotificationListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NotificationModel> items, int total, int page, int limit
});




}
/// @nodoc
class __$NotificationListResponseCopyWithImpl<$Res>
    implements _$NotificationListResponseCopyWith<$Res> {
  __$NotificationListResponseCopyWithImpl(this._self, this._then);

  final _NotificationListResponse _self;
  final $Res Function(_NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_NotificationListResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NotificationUnreadStatus {

@JsonKey(name: 'has_unread') bool get hasUnread;
/// Create a copy of NotificationUnreadStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationUnreadStatusCopyWith<NotificationUnreadStatus> get copyWith => _$NotificationUnreadStatusCopyWithImpl<NotificationUnreadStatus>(this as NotificationUnreadStatus, _$identity);

  /// Serializes this NotificationUnreadStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationUnreadStatus&&(identical(other.hasUnread, hasUnread) || other.hasUnread == hasUnread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasUnread);

@override
String toString() {
  return 'NotificationUnreadStatus(hasUnread: $hasUnread)';
}


}

/// @nodoc
abstract mixin class $NotificationUnreadStatusCopyWith<$Res>  {
  factory $NotificationUnreadStatusCopyWith(NotificationUnreadStatus value, $Res Function(NotificationUnreadStatus) _then) = _$NotificationUnreadStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'has_unread') bool hasUnread
});




}
/// @nodoc
class _$NotificationUnreadStatusCopyWithImpl<$Res>
    implements $NotificationUnreadStatusCopyWith<$Res> {
  _$NotificationUnreadStatusCopyWithImpl(this._self, this._then);

  final NotificationUnreadStatus _self;
  final $Res Function(NotificationUnreadStatus) _then;

/// Create a copy of NotificationUnreadStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasUnread = null,}) {
  return _then(_self.copyWith(
hasUnread: null == hasUnread ? _self.hasUnread : hasUnread // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationUnreadStatus].
extension NotificationUnreadStatusPatterns on NotificationUnreadStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationUnreadStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationUnreadStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationUnreadStatus value)  $default,){
final _that = this;
switch (_that) {
case _NotificationUnreadStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationUnreadStatus value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationUnreadStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_unread')  bool hasUnread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationUnreadStatus() when $default != null:
return $default(_that.hasUnread);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'has_unread')  bool hasUnread)  $default,) {final _that = this;
switch (_that) {
case _NotificationUnreadStatus():
return $default(_that.hasUnread);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'has_unread')  bool hasUnread)?  $default,) {final _that = this;
switch (_that) {
case _NotificationUnreadStatus() when $default != null:
return $default(_that.hasUnread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationUnreadStatus implements NotificationUnreadStatus {
  const _NotificationUnreadStatus({@JsonKey(name: 'has_unread') this.hasUnread = false});
  factory _NotificationUnreadStatus.fromJson(Map<String, dynamic> json) => _$NotificationUnreadStatusFromJson(json);

@override@JsonKey(name: 'has_unread') final  bool hasUnread;

/// Create a copy of NotificationUnreadStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationUnreadStatusCopyWith<_NotificationUnreadStatus> get copyWith => __$NotificationUnreadStatusCopyWithImpl<_NotificationUnreadStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationUnreadStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationUnreadStatus&&(identical(other.hasUnread, hasUnread) || other.hasUnread == hasUnread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasUnread);

@override
String toString() {
  return 'NotificationUnreadStatus(hasUnread: $hasUnread)';
}


}

/// @nodoc
abstract mixin class _$NotificationUnreadStatusCopyWith<$Res> implements $NotificationUnreadStatusCopyWith<$Res> {
  factory _$NotificationUnreadStatusCopyWith(_NotificationUnreadStatus value, $Res Function(_NotificationUnreadStatus) _then) = __$NotificationUnreadStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'has_unread') bool hasUnread
});




}
/// @nodoc
class __$NotificationUnreadStatusCopyWithImpl<$Res>
    implements _$NotificationUnreadStatusCopyWith<$Res> {
  __$NotificationUnreadStatusCopyWithImpl(this._self, this._then);

  final _NotificationUnreadStatus _self;
  final $Res Function(_NotificationUnreadStatus) _then;

/// Create a copy of NotificationUnreadStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasUnread = null,}) {
  return _then(_NotificationUnreadStatus(
hasUnread: null == hasUnread ? _self.hasUnread : hasUnread // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
