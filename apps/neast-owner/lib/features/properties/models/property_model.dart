import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target

part 'property_model.freezed.dart';
part 'property_model.g.dart';

@freezed
abstract class PropertyModel with _$PropertyModel {
  const factory PropertyModel({
    @Default(0) int id,
    @Default('') String sn,
    @Default('') String name,
    @Default('') String address,
    @Default('') String image,
    @Default('') String file,
    @JsonKey(name: 'landlord_id') @Default(0) int landlordId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _PropertyModel;

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);
}

class PropertyListResponse {
  const PropertyListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<PropertyModel> items;
  final int total;
  final int page;
  final int limit;

  factory PropertyListResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map(
              (item) => PropertyModel.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList()
        : <PropertyModel>[];

    return PropertyListResponse(
      items: items,
      total: _readInt(json['total']),
      page: _readInt(json['page'], fallback: 1),
      limit: _readInt(json['limit'], fallback: 20),
    );
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
