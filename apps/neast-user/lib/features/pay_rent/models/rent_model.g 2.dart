// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RentModel _$RentModelFromJson(Map<String, dynamic> json) => _RentModel(
  id: (json['id'] as num).toInt(),
  amount: json['amount'] == null ? '0' : _amountFromJson(json['amount']),
  file: json['file'] as String? ?? '',
  fileUrl: json['file_url'] as String? ?? '',
  paidAt: (json['paid_at'] as num?)?.toInt() ?? 1,
  firstPayMonth: json['first_pay_month'] as String? ?? '',
  leaseMonths: (json['lease_months'] as num?)?.toInt() ?? 0,
  expireDate: json['expire_date'] as String? ?? '',
  status: (json['status'] as num?)?.toInt() ?? 0,
  landlordId: (json['landlord_id'] as num?)?.toInt(),
  landlordName: json['landlord_name'] as String? ?? '',
  landlordAccountName: json['landlord_account_name'] as String? ?? '',
  propertyName: json['property_name'] as String? ?? '',
  earnPoints: (json['earn_points'] as num?)?.toInt() ?? 0,
  createdAt: json['created_at'] as String? ?? '',
  canPay: json['can_pay'] as bool? ?? false,
  dueText: json['due_text'] as String? ?? '',
  dateLabel: json['date_label'] as String? ?? '',
);

Map<String, dynamic> _$RentModelToJson(_RentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'file': instance.file,
      'file_url': instance.fileUrl,
      'paid_at': instance.paidAt,
      'first_pay_month': instance.firstPayMonth,
      'lease_months': instance.leaseMonths,
      'expire_date': instance.expireDate,
      'status': instance.status,
      'landlord_id': instance.landlordId,
      'landlord_name': instance.landlordName,
      'landlord_account_name': instance.landlordAccountName,
      'property_name': instance.propertyName,
      'earn_points': instance.earnPoints,
      'created_at': instance.createdAt,
      'can_pay': instance.canPay,
      'due_text': instance.dueText,
      'date_label': instance.dateLabel,
    };

_RentListResponse _$RentListResponseFromJson(Map<String, dynamic> json) =>
    _RentListResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => RentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      rentPointsMultiplier:
          (json['rent_points_multiplier'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$RentListResponseToJson(_RentListResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'rent_points_multiplier': instance.rentPointsMultiplier,
    };
