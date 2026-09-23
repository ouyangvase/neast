import 'package:freezed_annotation/freezed_annotation.dart';

part 'rent_model.freezed.dart';
part 'rent_model.g.dart';

// ignore_for_file: invalid_annotation_target

String _amountFromJson(dynamic value) {
  if (value == null) return '0';
  return value.toString();
}

@freezed
abstract class RentModel with _$RentModel {
  const RentModel._();

  const factory RentModel({
    required int id,
    @JsonKey(fromJson: _amountFromJson) @Default('0') String amount,
    @Default('') String file,
    @JsonKey(name: 'file_url') @Default('') String fileUrl,
    @JsonKey(name: 'paid_at') @Default(1) int paidAt,
    @JsonKey(name: 'first_pay_month') @Default('') String firstPayMonth,
    @JsonKey(name: 'lease_months') @Default(0) int leaseMonths,
    @JsonKey(name: 'expire_date') @Default('') String expireDate,
    @Default(0) int status,
    @JsonKey(name: 'landlord_id') int? landlordId,
    @JsonKey(name: 'landlord_name') @Default('') String landlordName,
    @JsonKey(name: 'landlord_account_name') @Default('') String landlordAccountName,
    @JsonKey(name: 'landlord_bank_name') @Default('') String landlordBankName,
    @JsonKey(name: 'landlord_bank_last4') @Default('') String landlordBankLast4,
    @JsonKey(name: 'payout_status') @Default('') String payoutStatus,
    @JsonKey(name: 'invite_sent') @Default(false) bool inviteSent,
    @JsonKey(name: 'property_name') @Default('') String propertyName,
    @JsonKey(name: 'earn_points') @Default(0) int earnPoints,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'can_pay') @Default(false) bool canPay,
    @JsonKey(name: 'due_text') @Default('') String dueText,
    @JsonKey(name: 'date_label') @Default('') String dateLabel,
  }) = _RentModel;

  factory RentModel.fromJson(Map<String, dynamic> json) =>
      _$RentModelFromJson(json);

  bool get hasLandlord =>
      landlordId != null && landlordId! > 0 && displayLandlordName.isNotEmpty;

  /// 卡片副标题：优先房东姓名，其次审核填写的账号名称。
  String get displayLandlordName {
    if (landlordName.isNotEmpty) return landlordName;
    if (landlordAccountName.isNotEmpty) return landlordAccountName;
    return '';
  }

  /// 卡片主标题：优先房产名，否则占位文案。
  String get displayPropertyTitle =>
      propertyName.isNotEmpty ? propertyName : 'My Tenancy';

  /// 租期：`Jan 2025 - Jul 2026`（起始取 created_at，结束取 expire_date）。
  String get displayLeasePeriod {
    final start = _parseDate(createdAt);
    final end = _parseDate(expireDate);
    if (start == null && end == null) return '';
    final startLabel = start != null ? _monthYearLabel(start) : '';
    final endLabel = end != null ? _monthYearLabel(end) : '';
    if (startLabel.isEmpty) return endLabel;
    if (endLabel.isEmpty) return startLabel;
    return '$startLabel - $endLabel';
  }

  /// 是否允许用户终止（与后台 Terminate 按钮条件一致）。
  bool get canTerminate =>
      status == RentStatus.approved || status == RentStatus.pendingBind;

  /// 交租提示：`Due in N days · 5 Aug 2026`（后端计算）。
  String get displayDueText {
    if (dueText.isEmpty && dateLabel.isEmpty) return '';
    if (dueText.isEmpty) return dateLabel;
    if (dateLabel.isEmpty) return dueText;
    return '$dueText · $dateLabel';
  }

  String get ownerPathLabel =>
      hasLandlord ? 'Owner on NEAST' : 'Owner not on NEAST';

  String get destinationBankLabel {
    if (landlordBankLast4.isEmpty) return '';
    if (landlordBankName.isEmpty) return 'Bank ****$landlordBankLast4';
    return '$landlordBankName ****$landlordBankLast4';
  }

  bool get isPayoutQueued => payoutStatus == 'queued';

  bool get isHeldPayout =>
      payoutStatus == 'held' || payoutStatus == 'invited';

  static String _monthYearLabel(DateTime date) =>
      '${_shortMonths[date.month - 1]} ${date.year}';

  static DateTime? _parseDate(String value) {
    if (value.isEmpty) return null;
    final datePart = value.split(' ').first;
    final parts = datePart.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }

  static const _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}

/// t_rent.status 与后端 RentModel 一致。
abstract final class RentStatus {
  static const pending = 0;
  static const approved = 1;
  static const rejected = 2;
  static const pendingBind = 3;
  static const terminated = 4;
}

@freezed
abstract class RentListResponse with _$RentListResponse {
  const factory RentListResponse({
    @Default([]) List<RentModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int limit,
    @JsonKey(name: 'rent_points_multiplier')
    @Default(1.0)
    double rentPointsMultiplier,
  }) = _RentListResponse;

  factory RentListResponse.fromJson(Map<String, dynamic> json) =>
      _$RentListResponseFromJson(json);
}
