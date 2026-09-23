import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neast/features/pay_rent/utils/rent_file_actions.dart';

part 'rent_history_model.freezed.dart';
part 'rent_history_model.g.dart';

// ignore_for_file: invalid_annotation_target

String _amountFromJson(dynamic value) {
  if (value == null) return '0';
  return value.toString();
}

/// Property Journey 单月状态。
enum RentJourneyMonthStatus {
  onTime,
  late,
  upcoming,
}

@freezed
abstract class RentHistoryModel with _$RentHistoryModel {
  const RentHistoryModel._();

  const factory RentHistoryModel({
    required int id,
    @JsonKey(name: 'rent_id') required int rentId,
    @JsonKey(name: 'last_paid_date') @Default('') String lastPaidDate,
    @JsonKey(name: 'user_paid_at') @Default('') String userPaidAt,
    @Default(0) int status,
    @JsonKey(name: 'display_status') @Default('pending') String displayStatus,
    @JsonKey(name: 'pay_status') @Default('upcoming') String payStatus,
    @JsonKey(fromJson: _amountFromJson) @Default('0') String amount,
    @JsonKey(name: 'property_address') @Default('') String propertyAddress,
    @JsonKey(name: 'landlord_account_name') @Default('') String landlordAccountName,
    @JsonKey(name: 'landlord_name') @Default('') String landlordName,
    @JsonKey(name: 'landlord_id') int? landlordId,
    @JsonKey(name: 'landlord_bank_last4') @Default('') String landlordBankLast4,
    @JsonKey(name: 'payout_status') @Default('') String payoutStatus,
    @JsonKey(name: 'payment_method') @Default('') String paymentMethod,
    @JsonKey(name: 'payment_no') @Default('') String paymentNo,
    @JsonKey(name: 'rental_period') @Default('') String rentalPeriod,
  }) = _RentHistoryModel;

  factory RentHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$RentHistoryModelFromJson(json);

  String get displayTitle {
    if (propertyAddress.isNotEmpty) return propertyAddress;
    if (landlordAccountName.isNotEmpty) return landlordAccountName;
    return 'Rent Payment';
  }

  String get displayDate => formatRentExpireDate(lastPaidDate);

  String get displayAmount => formatRentAmount(amount);

  bool get isPaidDetailAvailable => status == 1 || status == 2;

  bool get isHeldPayout =>
      payoutStatus == 'held' || payoutStatus == 'invited';

  bool get isPayoutQueued => payoutStatus == 'queued';

  String get payoutHeadline {
    if (isPayoutQueued) {
      final bank = landlordBankLast4.isEmpty
          ? 'owner bank'
          : '****$landlordBankLast4';
      return 'Paid to NEAST · Payout queued to $bank';
    }
    if (payoutStatus == 'invited') {
      return 'Held by NEAST · Owner invite sent';
    }
    if (isHeldPayout) {
      return 'Held by NEAST until the owner joins';
    }
    return 'Your rent payment has been recorded successfully';
  }

  String get displayPaymentMethod {
    final method = paymentMethod.trim();
    if (method.isEmpty) return '-';

    const labels = {
      'wallet': 'Wallet',
      'fpx': 'FPX',
      'tng': 'TNG',
      'grab': 'GRAB',
      'visa': 'Visa/Master',
    };

    return labels[method.toLowerCase()] ?? method;
  }

  String get paidOnLabel {
    if (userPaidAt.trim().isEmpty) return '-';
    final datePart = userPaidAt.split(' ').first;
    final parts = datePart.split('-');
    if (parts.length != 3) return userPaidAt;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return userPaidAt;
    if (month < 1 || month > 12) return userPaidAt;
    return '$day ${_shortMonths[month - 1]} $year';
  }

  String get displayRentalPeriod {
    if (rentalPeriod.trim().isNotEmpty) return rentalPeriod.trim();
    final date = _parseDate(lastPaidDate);
    if (date == null) return '-';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Property Journey 状态，直接读取接口返回的 pay_status。
  RentJourneyMonthStatus get journeyStatus {
    switch (payStatus) {
      case 'on_time':
        return RentJourneyMonthStatus.onTime;
      case 'late':
        return RentJourneyMonthStatus.late;
      default:
        return RentJourneyMonthStatus.upcoming;
    }
  }

  /// 月份缩写，如 JAN。
  String get journeyMonthLabel {
    final date = _parseDate(lastPaidDate);
    if (date == null) return '';
    return _shortMonths[date.month - 1];
  }

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
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
}

@freezed
abstract class RentHistoryListResponse with _$RentHistoryListResponse {
  const factory RentHistoryListResponse({
    @Default([]) List<RentHistoryModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(15) int limit,
  }) = _RentHistoryListResponse;

  factory RentHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$RentHistoryListResponseFromJson(json);
}

@freezed
abstract class RentPayOrder with _$RentPayOrder {
  const factory RentPayOrder({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'payment_url') @Default('') String paymentUrl,
    @JsonKey(name: 'history_id') required int historyId,
  }) = _RentPayOrder;

  factory RentPayOrder.fromJson(Map<String, dynamic> json) =>
      _$RentPayOrderFromJson(json);
}
