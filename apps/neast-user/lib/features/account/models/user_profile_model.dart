import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @Default('') String userId,
    @Default('') String account,
    @Default('') String email,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('id_card') String idType,
    @Default('') String idNumber,
    String? idValidUntil,
    @Default('') String address,
    @Default(false) bool profileCompleted,
    @Default(0) int points,
    @Default(0) double pointsApproxRm,
    @Default('') String qrCode,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  String get fullName {
    final name = '${firstName.trim()} ${lastName.trim()}'.trim();
    if (name.isNotEmpty) {
      return name;
    }
    return account;
  }

  /// 首页问候语用名，优先 firstName。
  String get greetingName {
    if (firstName.trim().isNotEmpty) {
      return firstName.trim();
    }
    return fullName;
  }

  String get avatarLetter {
    if (firstName.trim().isNotEmpty) {
      return firstName.trim()[0].toUpperCase();
    }
    if (account.isNotEmpty) {
      return account[0].toUpperCase();
    }
    return '?';
  }

  bool get isIdCard => idType == 'id_card';

  String get idTypeLabel => idType == 'passport' ? 'Passport' : 'ID card';

  String get accountLabel => 'Phone Number';

  String get pointsDisplay =>
      NumberFormat('#,###').format(points);

  String get pointsValueDisplay =>
      '≈ RM${pointsApproxRm.toStringAsFixed(2)}';
}
