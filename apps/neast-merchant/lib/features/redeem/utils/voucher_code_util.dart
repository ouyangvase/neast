import 'package:neast/core/utils/toast_util.dart';

final _manualSnPattern = RegExp(r'^[A-Z0-9]{6}$');
final _redeemTokenPattern = RegExp(r'^[a-f0-9]{32}$', caseSensitive: false);

String normalizeManualSn(String raw) => raw.trim().toUpperCase();

bool isValidManualSn(String sn) => _manualSnPattern.hasMatch(sn);

bool isRedeemToken(String raw) => _redeemTokenPattern.hasMatch(raw.trim());

String normalizeScanCode(String raw) => raw.trim();

bool validateManualSnOrToast(String raw) {
  final sn = normalizeManualSn(raw);
  if (!isValidManualSn(sn)) {
    ToastUtil.show('Invalid voucher code');
    return false;
  }
  return true;
}
