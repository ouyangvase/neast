// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_topup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletTopupModel _$WalletTopupModelFromJson(Map<String, dynamic> json) =>
    _WalletTopupModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      amount: json['amount'] == null ? '0' : _amountFromJson(json['amount']),
      paymentMethod: json['payment_method'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      status: json['status'] == null ? 0 : _statusFromJson(json['status']),
      txnId: json['txn_id'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
      paidAt: json['paid_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );

Map<String, dynamic> _$WalletTopupModelToJson(_WalletTopupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
      'order_id': instance.orderId,
      'status': instance.status,
      'txn_id': instance.txnId,
      'channel': instance.channel,
      'paid_at': instance.paidAt,
      'created_at': instance.createdAt,
    };

_WalletTopupListResponse _$WalletTopupListResponseFromJson(
  Map<String, dynamic> json,
) => _WalletTopupListResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => WalletTopupModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 15,
);

Map<String, dynamic> _$WalletTopupListResponseToJson(
  _WalletTopupListResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

_WalletTopupOrder _$WalletTopupOrderFromJson(Map<String, dynamic> json) =>
    _WalletTopupOrder(
      orderId: json['order_id'] as String,
      paymentUrl: json['payment_url'] as String? ?? '',
    );

Map<String, dynamic> _$WalletTopupOrderToJson(_WalletTopupOrder instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'payment_url': instance.paymentUrl,
    };

_WalletTopupResult _$WalletTopupResultFromJson(Map<String, dynamic> json) =>
    _WalletTopupResult(
      balance: json['balance'] as String? ?? '0.00',
      topup: json['topup'] == null
          ? null
          : WalletTopupModel.fromJson(json['topup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletTopupResultToJson(_WalletTopupResult instance) =>
    <String, dynamic>{'balance': instance.balance, 'topup': instance.topup};
