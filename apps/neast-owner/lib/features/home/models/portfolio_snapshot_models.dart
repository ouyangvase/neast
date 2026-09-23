import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

// ignore_for_file: invalid_annotation_target

part 'portfolio_snapshot_models.freezed.dart';
part 'portfolio_snapshot_models.g.dart';

String _readString(dynamic value) => value?.toString() ?? '0';

/// 资产概览租客项（对应 t_rent 记录关联的用户）。
@freezed
abstract class PortfolioTenantItem with _$PortfolioTenantItem {
  const factory PortfolioTenantItem({
    @Default(0) int id,
    @Default('') String initials,
    @Default('') String name,
    @Default('') String address,
    @Default('') String avatar,
  }) = _PortfolioTenantItem;

  factory PortfolioTenantItem.fromJson(Map<String, dynamic> json) =>
      _$PortfolioTenantItemFromJson(json);
}

/// 资产概览详情。
@freezed
abstract class PortfolioDetailModel with _$PortfolioDetailModel {
  const PortfolioDetailModel._();

  const factory PortfolioDetailModel({
    @JsonKey(name: 'rent_roll', fromJson: _readString) @Default('0') String rentRoll,
    @JsonKey(name: 'tenant_count') @Default(0) int tenantCount,
    @Default([]) List<PortfolioTenantItem> tenants,
  }) = _PortfolioDetailModel;

  factory PortfolioDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioDetailModelFromJson(json);

  String get displayRentRoll {
    final value = double.tryParse(rentRoll) ?? 0;
    return NumberFormat('#,##0', 'en_US').format(value);
  }
}
