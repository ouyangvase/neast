import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

// ignore_for_file: invalid_annotation_target

part 'landlord_rent_detail_model.freezed.dart';
part 'landlord_rent_detail_model.g.dart';

String _readAmountString(Object? value) => value?.toString() ?? '0';

/// 房东端租约详情。
@freezed
abstract class LandlordRentDetailModel with _$LandlordRentDetailModel {
  const LandlordRentDetailModel._();

  const factory LandlordRentDetailModel({
    @Default(0) int id,
    @JsonKey(name: 'tenant_name') @Default('') String tenantName,
    @JsonKey(name: 'tenant_initials') @Default('') String tenantInitials,
    @JsonKey(name: 'tenant_avatar') @Default('') String tenantAvatar,
    @JsonKey(name: 'property_name') @Default('') String propertyName,
    @JsonKey(name: 'property_address') @Default('') String propertyAddress,
    @JsonKey(fromJson: _readAmountString) @Default('0') String amount,
    @JsonKey(name: 'paid_at') @Default(0) int paidAt,
    @JsonKey(name: 'first_pay_month') @Default('') String firstPayMonth,
    @JsonKey(name: 'lease_months') @Default(0) int leaseMonths,
    @JsonKey(name: 'expire_date') @Default('') String expireDate,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'file_url') @Default('') String fileUrl,
    @Default(0) int status,
    @JsonKey(name: 'can_terminate') @Default(false) bool canTerminate,
  }) = _LandlordRentDetailModel;

  factory LandlordRentDetailModel.fromJson(Map<String, dynamic> json) =>
      _$LandlordRentDetailModelFromJson(json);

  String get displayAmount {
    final value = double.tryParse(amount) ?? 0;
    final formatted = value == value.roundToDouble()
        ? NumberFormat('#,##0', 'en_US').format(value.toInt())
        : NumberFormat('#,##0.00', 'en_US').format(value);
    return formatted;
  }

  String get displayPayDay =>
      paidAt > 0 ? 'Day $paidAt of each month' : '-';

  String get displayLeaseTerm =>
      leaseMonths > 0 ? '$leaseMonths months' : '-';

  String get displayExpireDate {
    final date = _parseDate(expireDate);
    if (date == null) return expireDate.isEmpty ? '-' : expireDate;
    return DateFormat('d MMM yyyy').format(date);
  }

  String get displayFirstPayMonth {
    if (firstPayMonth.isEmpty) return '-';
    final parts = firstPayMonth.split('-');
    if (parts.length != 2) return firstPayMonth;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null) return firstPayMonth;
    return DateFormat('MMM yyyy').format(DateTime(year, month));
  }

  String get displayLeasePeriod {
    final start = _parseDate(createdAt);
    final end = _parseDate(expireDate);
    if (start == null && end == null) return '-';
    final startLabel =
        start != null ? DateFormat('MMM yyyy').format(start) : '';
    final endLabel = end != null ? DateFormat('MMM yyyy').format(end) : '';
    if (startLabel.isEmpty) return endLabel;
    if (endLabel.isEmpty) return startLabel;
    return '$startLabel - $endLabel';
  }

  static DateTime? _parseDate(String value) {
    if (value.isEmpty) return null;
    final datePart = value.split(' ').first;
    return DateTime.tryParse(datePart);
  }
}
