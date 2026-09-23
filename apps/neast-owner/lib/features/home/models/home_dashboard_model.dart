import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:neast_landlords/features/home/models/ack_item_model.dart';
import 'package:neast_landlords/features/home/models/bind_request_item_model.dart';
import 'package:neast_landlords/features/home/models/rent_item_model.dart';

// ignore_for_file: invalid_annotation_target

part 'home_dashboard_model.freezed.dart';
part 'home_dashboard_model.g.dart';

String _readAmountString(Object? value) => value?.toString() ?? '0';

/// 首页 Header 统计。
@freezed
abstract class HomeHeaderModel with _$HomeHeaderModel {
  const HomeHeaderModel._();

  const factory HomeHeaderModel({
    @JsonKey(fromJson: _readAmountString) @Default('0') String collected,
    @JsonKey(name: 'collection_rate') @Default(0) int collectionRate,
    @JsonKey(name: 'overdue_amount', fromJson: _readAmountString)
    @Default('0')
    String overdueAmount,
  }) = _HomeHeaderModel;

  factory HomeHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$HomeHeaderModelFromJson(json);

  String get displayCollected {
    final value = double.tryParse(collected) ?? 0;
    return 'RM ${NumberFormat('#,##0.00', 'en_US').format(value)}';
  }

  String get displayOverdueAmount {
    final value = double.tryParse(overdueAmount) ?? 0;
    return NumberFormat('#,##0', 'en_US').format(value);
  }

  String get collectionRateText => '$collectionRate% Collection Rate';

  String get overdueAmountText => 'RM $displayOverdueAmount Overdue';
}

/// 首页待办统计。
@freezed
abstract class HomeNeedActionModel with _$HomeNeedActionModel {
  const HomeNeedActionModel._();

  const factory HomeNeedActionModel({
    @Default(0) int overdue,
    @JsonKey(name: 'due_soon') @Default(0) int dueSoon,
    @JsonKey(name: 'need_ack') @Default(0) int needAck,
    @JsonKey(name: 'bind_req') @Default(0) int bindReq,
  }) = _HomeNeedActionModel;

  factory HomeNeedActionModel.fromJson(Map<String, dynamic> json) =>
      _$HomeNeedActionModelFromJson(json);

  int get total => overdue + dueSoon + needAck + bindReq;

  String get tasksWaitingText =>
      total == 1 ? '1 task waiting' : '$total tasks waiting';
}

/// 首页 Portfolio 统计。
@freezed
abstract class HomePortfolioModel with _$HomePortfolioModel {
  const HomePortfolioModel._();

  const factory HomePortfolioModel({
    @Default(0) int properties,
    @Default(0) int tenants,
    @JsonKey(name: 'rent_roll', fromJson: _readAmountString)
    @Default('0')
    String rentRoll,
  }) = _HomePortfolioModel;

  factory HomePortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$HomePortfolioModelFromJson(json);

  String get displayRentRoll {
    final value = double.tryParse(rentRoll) ?? 0;
    return 'RM${NumberFormat('#,##0', 'en_US').format(value)}';
  }
}

/// 首页聚合数据。
@freezed
abstract class HomeDashboardModel with _$HomeDashboardModel {
  const factory HomeDashboardModel({
    @JsonKey(name: 'has_unread_message') @Default(false) bool hasUnreadMessage,
    required HomeHeaderModel header,
    @JsonKey(name: 'need_action') required HomeNeedActionModel needAction,
    @JsonKey(name: 'overdue_list')
    @Default(<RentItemModel>[])
    List<RentItemModel> overdueList,
    @JsonKey(name: 'due_soon_list')
    @Default(<RentItemModel>[])
    List<RentItemModel> dueSoonList,
    @JsonKey(name: 'need_ack') AckItemModel? needAck,
    @JsonKey(name: 'bind_request') BindRequestItemModel? bindRequest,
    required HomePortfolioModel portfolio,
  }) = _HomeDashboardModel;

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardModelFromJson(json);
}
