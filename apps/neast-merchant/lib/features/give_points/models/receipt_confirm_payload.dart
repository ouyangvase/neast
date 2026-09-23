import 'package:neast/features/give_points/models/receipt_capture_result.dart';
import 'package:neast/features/give_points/utils/give_points_points_util.dart';

/// Step 1 表单数据，用于跳转 Confirm Points。
class ReceiptConfirmPayload {
  const ReceiptConfirmPayload({
    required this.capture,
    required this.outlet,
    required this.merchantId,
    required this.receiptNumber,
    required this.amountText,
    required this.yuanToPoints,
    this.notes = '',
  });

  final ReceiptCaptureResult capture;
  final String outlet;
  final int merchantId;
  final String receiptNumber;
  final String amountText;
  final int yuanToPoints;
  final String notes;

  int get autoPoints =>
      GivePointsPointsUtil.pointsFromAmount(amountText, yuanToPoints);

  String get formattedAmount =>
      GivePointsPointsUtil.formatAmountDisplay(amountText);
}
