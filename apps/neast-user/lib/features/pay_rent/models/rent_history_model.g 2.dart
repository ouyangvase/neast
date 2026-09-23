// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RentHistoryModel _$RentHistoryModelFromJson(Map<String, dynamic> json) =>
    _RentHistoryModel(
      id: (json['id'] as num).toInt(),
      rentId: (json['rent_id'] as num).toInt(),
      lastPaidDate: json['last_paid_date'] as String? ?? '',
      userPaidAt: json['user_paid_at'] as String? ?? '',
      status: (json['status'] as num?)?.toInt() ?? 0,
      displayStatus: json['display_status'] as String? ?? 'pending',
      payStatus: json['pay_status'] as String? ?? 'upcoming',
      amount: json['amount'] == null ? '0' : _amountFromJson(json['amount']),
      propertyAddress: json['property_address'] as String? ?? '',
      landlordAccountName: json['landlord_account_name'] as String? ?? '',
      paymentMethod: json['payment_method'] as String? ?? '',
      paymentNo: json['payment_no'] as String? ?? '',
      rentalPeriod: json['rental_period'] as String? ?? '',
    );

Map<String, dynamic> _$RentHistoryModelToJson(_RentHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rent_id': instance.rentId,
      'last_paid_date': instance.lastPaidDate,
      'user_paid_at': instance.userPaidAt,
      'status': instance.status,
      'display_status': instance.displayStatus,
      'pay_status': instance.payStatus,
      'amount': instance.amount,
      'property_address': instance.propertyAddress,
      'landlord_account_name': instance.landlordAccountName,
      'payment_method': instance.paymentMethod,
      'payment_no': instance.paymentNo,
      'rental_period': instance.rentalPeriod,
    };

_RentHistoryListResponse _$RentHistoryListResponseFromJson(
  Map<String, dynamic> json,
) => _RentHistoryListResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => RentHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 15,
);

Map<String, dynamic> _$RentHistoryListResponseToJson(
  _RentHistoryListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

_RentPayOrder _$RentPayOrderFromJson(Map<String, dynamic> json) =>
    _RentPayOrder(
      orderId: json['order_id'] as String,
      paymentUrl: json['payment_url'] as String? ?? '',
      historyId: (json['history_id'] as num).toInt(),
    );

Map<String, dynamic> _$RentPayOrderToJson(_RentPayOrder instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'payment_url': instance.paymentUrl,
      'history_id': instance.historyId,
    };
