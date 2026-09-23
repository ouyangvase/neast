// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeJourneyModel {

@JsonKey(name: 'maxStreakMonths') int get maxStreakMonths; String get streakLabel; String get streakStatus;
/// Create a copy of HomeJourneyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeJourneyModelCopyWith<HomeJourneyModel> get copyWith => _$HomeJourneyModelCopyWithImpl<HomeJourneyModel>(this as HomeJourneyModel, _$identity);

  /// Serializes this HomeJourneyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeJourneyModel&&(identical(other.maxStreakMonths, maxStreakMonths) || other.maxStreakMonths == maxStreakMonths)&&(identical(other.streakLabel, streakLabel) || other.streakLabel == streakLabel)&&(identical(other.streakStatus, streakStatus) || other.streakStatus == streakStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxStreakMonths,streakLabel,streakStatus);

@override
String toString() {
  return 'HomeJourneyModel(maxStreakMonths: $maxStreakMonths, streakLabel: $streakLabel, streakStatus: $streakStatus)';
}


}

/// @nodoc
abstract mixin class $HomeJourneyModelCopyWith<$Res>  {
  factory $HomeJourneyModelCopyWith(HomeJourneyModel value, $Res Function(HomeJourneyModel) _then) = _$HomeJourneyModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'maxStreakMonths') int maxStreakMonths, String streakLabel, String streakStatus
});




}
/// @nodoc
class _$HomeJourneyModelCopyWithImpl<$Res>
    implements $HomeJourneyModelCopyWith<$Res> {
  _$HomeJourneyModelCopyWithImpl(this._self, this._then);

  final HomeJourneyModel _self;
  final $Res Function(HomeJourneyModel) _then;

/// Create a copy of HomeJourneyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxStreakMonths = null,Object? streakLabel = null,Object? streakStatus = null,}) {
  return _then(_self.copyWith(
maxStreakMonths: null == maxStreakMonths ? _self.maxStreakMonths : maxStreakMonths // ignore: cast_nullable_to_non_nullable
as int,streakLabel: null == streakLabel ? _self.streakLabel : streakLabel // ignore: cast_nullable_to_non_nullable
as String,streakStatus: null == streakStatus ? _self.streakStatus : streakStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeJourneyModel].
extension HomeJourneyModelPatterns on HomeJourneyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeJourneyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeJourneyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeJourneyModel value)  $default,){
final _that = this;
switch (_that) {
case _HomeJourneyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeJourneyModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomeJourneyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'maxStreakMonths')  int maxStreakMonths,  String streakLabel,  String streakStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeJourneyModel() when $default != null:
return $default(_that.maxStreakMonths,_that.streakLabel,_that.streakStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'maxStreakMonths')  int maxStreakMonths,  String streakLabel,  String streakStatus)  $default,) {final _that = this;
switch (_that) {
case _HomeJourneyModel():
return $default(_that.maxStreakMonths,_that.streakLabel,_that.streakStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'maxStreakMonths')  int maxStreakMonths,  String streakLabel,  String streakStatus)?  $default,) {final _that = this;
switch (_that) {
case _HomeJourneyModel() when $default != null:
return $default(_that.maxStreakMonths,_that.streakLabel,_that.streakStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeJourneyModel implements HomeJourneyModel {
  const _HomeJourneyModel({@JsonKey(name: 'maxStreakMonths') this.maxStreakMonths = 0, this.streakLabel = '', this.streakStatus = ''});
  factory _HomeJourneyModel.fromJson(Map<String, dynamic> json) => _$HomeJourneyModelFromJson(json);

@override@JsonKey(name: 'maxStreakMonths') final  int maxStreakMonths;
@override@JsonKey() final  String streakLabel;
@override@JsonKey() final  String streakStatus;

/// Create a copy of HomeJourneyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeJourneyModelCopyWith<_HomeJourneyModel> get copyWith => __$HomeJourneyModelCopyWithImpl<_HomeJourneyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeJourneyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeJourneyModel&&(identical(other.maxStreakMonths, maxStreakMonths) || other.maxStreakMonths == maxStreakMonths)&&(identical(other.streakLabel, streakLabel) || other.streakLabel == streakLabel)&&(identical(other.streakStatus, streakStatus) || other.streakStatus == streakStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxStreakMonths,streakLabel,streakStatus);

@override
String toString() {
  return 'HomeJourneyModel(maxStreakMonths: $maxStreakMonths, streakLabel: $streakLabel, streakStatus: $streakStatus)';
}


}

/// @nodoc
abstract mixin class _$HomeJourneyModelCopyWith<$Res> implements $HomeJourneyModelCopyWith<$Res> {
  factory _$HomeJourneyModelCopyWith(_HomeJourneyModel value, $Res Function(_HomeJourneyModel) _then) = __$HomeJourneyModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'maxStreakMonths') int maxStreakMonths, String streakLabel, String streakStatus
});




}
/// @nodoc
class __$HomeJourneyModelCopyWithImpl<$Res>
    implements _$HomeJourneyModelCopyWith<$Res> {
  __$HomeJourneyModelCopyWithImpl(this._self, this._then);

  final _HomeJourneyModel _self;
  final $Res Function(_HomeJourneyModel) _then;

/// Create a copy of HomeJourneyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxStreakMonths = null,Object? streakLabel = null,Object? streakStatus = null,}) {
  return _then(_HomeJourneyModel(
maxStreakMonths: null == maxStreakMonths ? _self.maxStreakMonths : maxStreakMonths // ignore: cast_nullable_to_non_nullable
as int,streakLabel: null == streakLabel ? _self.streakLabel : streakLabel // ignore: cast_nullable_to_non_nullable
as String,streakStatus: null == streakStatus ? _self.streakStatus : streakStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HomeBannerModel {

 int get id; String get image;@JsonKey(name: 'image_url') String get imageUrl; String get link;
/// Create a copy of HomeBannerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeBannerModelCopyWith<HomeBannerModel> get copyWith => _$HomeBannerModelCopyWithImpl<HomeBannerModel>(this as HomeBannerModel, _$identity);

  /// Serializes this HomeBannerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeBannerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.link, link) || other.link == link));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,image,imageUrl,link);

@override
String toString() {
  return 'HomeBannerModel(id: $id, image: $image, imageUrl: $imageUrl, link: $link)';
}


}

/// @nodoc
abstract mixin class $HomeBannerModelCopyWith<$Res>  {
  factory $HomeBannerModelCopyWith(HomeBannerModel value, $Res Function(HomeBannerModel) _then) = _$HomeBannerModelCopyWithImpl;
@useResult
$Res call({
 int id, String image,@JsonKey(name: 'image_url') String imageUrl, String link
});




}
/// @nodoc
class _$HomeBannerModelCopyWithImpl<$Res>
    implements $HomeBannerModelCopyWith<$Res> {
  _$HomeBannerModelCopyWithImpl(this._self, this._then);

  final HomeBannerModel _self;
  final $Res Function(HomeBannerModel) _then;

/// Create a copy of HomeBannerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? image = null,Object? imageUrl = null,Object? link = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeBannerModel].
extension HomeBannerModelPatterns on HomeBannerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeBannerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeBannerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeBannerModel value)  $default,){
final _that = this;
switch (_that) {
case _HomeBannerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeBannerModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomeBannerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String image, @JsonKey(name: 'image_url')  String imageUrl,  String link)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeBannerModel() when $default != null:
return $default(_that.id,_that.image,_that.imageUrl,_that.link);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String image, @JsonKey(name: 'image_url')  String imageUrl,  String link)  $default,) {final _that = this;
switch (_that) {
case _HomeBannerModel():
return $default(_that.id,_that.image,_that.imageUrl,_that.link);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String image, @JsonKey(name: 'image_url')  String imageUrl,  String link)?  $default,) {final _that = this;
switch (_that) {
case _HomeBannerModel() when $default != null:
return $default(_that.id,_that.image,_that.imageUrl,_that.link);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeBannerModel implements HomeBannerModel {
  const _HomeBannerModel({required this.id, this.image = '', @JsonKey(name: 'image_url') this.imageUrl = '', this.link = ''});
  factory _HomeBannerModel.fromJson(Map<String, dynamic> json) => _$HomeBannerModelFromJson(json);

@override final  int id;
@override@JsonKey() final  String image;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey() final  String link;

/// Create a copy of HomeBannerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeBannerModelCopyWith<_HomeBannerModel> get copyWith => __$HomeBannerModelCopyWithImpl<_HomeBannerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeBannerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeBannerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.image, image) || other.image == image)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.link, link) || other.link == link));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,image,imageUrl,link);

@override
String toString() {
  return 'HomeBannerModel(id: $id, image: $image, imageUrl: $imageUrl, link: $link)';
}


}

/// @nodoc
abstract mixin class _$HomeBannerModelCopyWith<$Res> implements $HomeBannerModelCopyWith<$Res> {
  factory _$HomeBannerModelCopyWith(_HomeBannerModel value, $Res Function(_HomeBannerModel) _then) = __$HomeBannerModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String image,@JsonKey(name: 'image_url') String imageUrl, String link
});




}
/// @nodoc
class __$HomeBannerModelCopyWithImpl<$Res>
    implements _$HomeBannerModelCopyWith<$Res> {
  __$HomeBannerModelCopyWithImpl(this._self, this._then);

  final _HomeBannerModel _self;
  final $Res Function(_HomeBannerModel) _then;

/// Create a copy of HomeBannerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? image = null,Object? imageUrl = null,Object? link = null,}) {
  return _then(_HomeBannerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HomeDashboardModel {

@JsonKey(name: 'nextRent') RentModel? get nextRent;@JsonKey(name: 'todayReward') CouponModel? get todayReward;@JsonKey(name: 'nearbyDeals') List<MerchantModel> get nearbyDeals; HomeJourneyModel get journey; List<HomeBannerModel> get banners;
/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDashboardModelCopyWith<HomeDashboardModel> get copyWith => _$HomeDashboardModelCopyWithImpl<HomeDashboardModel>(this as HomeDashboardModel, _$identity);

  /// Serializes this HomeDashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeDashboardModel&&(identical(other.nextRent, nextRent) || other.nextRent == nextRent)&&(identical(other.todayReward, todayReward) || other.todayReward == todayReward)&&const DeepCollectionEquality().equals(other.nearbyDeals, nearbyDeals)&&(identical(other.journey, journey) || other.journey == journey)&&const DeepCollectionEquality().equals(other.banners, banners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextRent,todayReward,const DeepCollectionEquality().hash(nearbyDeals),journey,const DeepCollectionEquality().hash(banners));

@override
String toString() {
  return 'HomeDashboardModel(nextRent: $nextRent, todayReward: $todayReward, nearbyDeals: $nearbyDeals, journey: $journey, banners: $banners)';
}


}

/// @nodoc
abstract mixin class $HomeDashboardModelCopyWith<$Res>  {
  factory $HomeDashboardModelCopyWith(HomeDashboardModel value, $Res Function(HomeDashboardModel) _then) = _$HomeDashboardModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'nextRent') RentModel? nextRent,@JsonKey(name: 'todayReward') CouponModel? todayReward,@JsonKey(name: 'nearbyDeals') List<MerchantModel> nearbyDeals, HomeJourneyModel journey, List<HomeBannerModel> banners
});


$RentModelCopyWith<$Res>? get nextRent;$CouponModelCopyWith<$Res>? get todayReward;$HomeJourneyModelCopyWith<$Res> get journey;

}
/// @nodoc
class _$HomeDashboardModelCopyWithImpl<$Res>
    implements $HomeDashboardModelCopyWith<$Res> {
  _$HomeDashboardModelCopyWithImpl(this._self, this._then);

  final HomeDashboardModel _self;
  final $Res Function(HomeDashboardModel) _then;

/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextRent = freezed,Object? todayReward = freezed,Object? nearbyDeals = null,Object? journey = null,Object? banners = null,}) {
  return _then(_self.copyWith(
nextRent: freezed == nextRent ? _self.nextRent : nextRent // ignore: cast_nullable_to_non_nullable
as RentModel?,todayReward: freezed == todayReward ? _self.todayReward : todayReward // ignore: cast_nullable_to_non_nullable
as CouponModel?,nearbyDeals: null == nearbyDeals ? _self.nearbyDeals : nearbyDeals // ignore: cast_nullable_to_non_nullable
as List<MerchantModel>,journey: null == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as HomeJourneyModel,banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<HomeBannerModel>,
  ));
}
/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RentModelCopyWith<$Res>? get nextRent {
    if (_self.nextRent == null) {
    return null;
  }

  return $RentModelCopyWith<$Res>(_self.nextRent!, (value) {
    return _then(_self.copyWith(nextRent: value));
  });
}/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CouponModelCopyWith<$Res>? get todayReward {
    if (_self.todayReward == null) {
    return null;
  }

  return $CouponModelCopyWith<$Res>(_self.todayReward!, (value) {
    return _then(_self.copyWith(todayReward: value));
  });
}/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeJourneyModelCopyWith<$Res> get journey {
  
  return $HomeJourneyModelCopyWith<$Res>(_self.journey, (value) {
    return _then(_self.copyWith(journey: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeDashboardModel].
extension HomeDashboardModelPatterns on HomeDashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeDashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeDashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeDashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'nextRent')  RentModel? nextRent, @JsonKey(name: 'todayReward')  CouponModel? todayReward, @JsonKey(name: 'nearbyDeals')  List<MerchantModel> nearbyDeals,  HomeJourneyModel journey,  List<HomeBannerModel> banners)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
return $default(_that.nextRent,_that.todayReward,_that.nearbyDeals,_that.journey,_that.banners);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'nextRent')  RentModel? nextRent, @JsonKey(name: 'todayReward')  CouponModel? todayReward, @JsonKey(name: 'nearbyDeals')  List<MerchantModel> nearbyDeals,  HomeJourneyModel journey,  List<HomeBannerModel> banners)  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardModel():
return $default(_that.nextRent,_that.todayReward,_that.nearbyDeals,_that.journey,_that.banners);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'nextRent')  RentModel? nextRent, @JsonKey(name: 'todayReward')  CouponModel? todayReward, @JsonKey(name: 'nearbyDeals')  List<MerchantModel> nearbyDeals,  HomeJourneyModel journey,  List<HomeBannerModel> banners)?  $default,) {final _that = this;
switch (_that) {
case _HomeDashboardModel() when $default != null:
return $default(_that.nextRent,_that.todayReward,_that.nearbyDeals,_that.journey,_that.banners);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeDashboardModel implements HomeDashboardModel {
  const _HomeDashboardModel({@JsonKey(name: 'nextRent') this.nextRent, @JsonKey(name: 'todayReward') this.todayReward, @JsonKey(name: 'nearbyDeals') final  List<MerchantModel> nearbyDeals = const [], this.journey = const HomeJourneyModel(), final  List<HomeBannerModel> banners = const []}): _nearbyDeals = nearbyDeals,_banners = banners;
  factory _HomeDashboardModel.fromJson(Map<String, dynamic> json) => _$HomeDashboardModelFromJson(json);

@override@JsonKey(name: 'nextRent') final  RentModel? nextRent;
@override@JsonKey(name: 'todayReward') final  CouponModel? todayReward;
 final  List<MerchantModel> _nearbyDeals;
@override@JsonKey(name: 'nearbyDeals') List<MerchantModel> get nearbyDeals {
  if (_nearbyDeals is EqualUnmodifiableListView) return _nearbyDeals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nearbyDeals);
}

@override@JsonKey() final  HomeJourneyModel journey;
 final  List<HomeBannerModel> _banners;
@override@JsonKey() List<HomeBannerModel> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}


/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDashboardModelCopyWith<_HomeDashboardModel> get copyWith => __$HomeDashboardModelCopyWithImpl<_HomeDashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeDashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeDashboardModel&&(identical(other.nextRent, nextRent) || other.nextRent == nextRent)&&(identical(other.todayReward, todayReward) || other.todayReward == todayReward)&&const DeepCollectionEquality().equals(other._nearbyDeals, _nearbyDeals)&&(identical(other.journey, journey) || other.journey == journey)&&const DeepCollectionEquality().equals(other._banners, _banners));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextRent,todayReward,const DeepCollectionEquality().hash(_nearbyDeals),journey,const DeepCollectionEquality().hash(_banners));

@override
String toString() {
  return 'HomeDashboardModel(nextRent: $nextRent, todayReward: $todayReward, nearbyDeals: $nearbyDeals, journey: $journey, banners: $banners)';
}


}

/// @nodoc
abstract mixin class _$HomeDashboardModelCopyWith<$Res> implements $HomeDashboardModelCopyWith<$Res> {
  factory _$HomeDashboardModelCopyWith(_HomeDashboardModel value, $Res Function(_HomeDashboardModel) _then) = __$HomeDashboardModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'nextRent') RentModel? nextRent,@JsonKey(name: 'todayReward') CouponModel? todayReward,@JsonKey(name: 'nearbyDeals') List<MerchantModel> nearbyDeals, HomeJourneyModel journey, List<HomeBannerModel> banners
});


@override $RentModelCopyWith<$Res>? get nextRent;@override $CouponModelCopyWith<$Res>? get todayReward;@override $HomeJourneyModelCopyWith<$Res> get journey;

}
/// @nodoc
class __$HomeDashboardModelCopyWithImpl<$Res>
    implements _$HomeDashboardModelCopyWith<$Res> {
  __$HomeDashboardModelCopyWithImpl(this._self, this._then);

  final _HomeDashboardModel _self;
  final $Res Function(_HomeDashboardModel) _then;

/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextRent = freezed,Object? todayReward = freezed,Object? nearbyDeals = null,Object? journey = null,Object? banners = null,}) {
  return _then(_HomeDashboardModel(
nextRent: freezed == nextRent ? _self.nextRent : nextRent // ignore: cast_nullable_to_non_nullable
as RentModel?,todayReward: freezed == todayReward ? _self.todayReward : todayReward // ignore: cast_nullable_to_non_nullable
as CouponModel?,nearbyDeals: null == nearbyDeals ? _self._nearbyDeals : nearbyDeals // ignore: cast_nullable_to_non_nullable
as List<MerchantModel>,journey: null == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as HomeJourneyModel,banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<HomeBannerModel>,
  ));
}

/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RentModelCopyWith<$Res>? get nextRent {
    if (_self.nextRent == null) {
    return null;
  }

  return $RentModelCopyWith<$Res>(_self.nextRent!, (value) {
    return _then(_self.copyWith(nextRent: value));
  });
}/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CouponModelCopyWith<$Res>? get todayReward {
    if (_self.todayReward == null) {
    return null;
  }

  return $CouponModelCopyWith<$Res>(_self.todayReward!, (value) {
    return _then(_self.copyWith(todayReward: value));
  });
}/// Create a copy of HomeDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeJourneyModelCopyWith<$Res> get journey {
  
  return $HomeJourneyModelCopyWith<$Res>(_self.journey, (value) {
    return _then(_self.copyWith(journey: value));
  });
}
}

// dart format on
