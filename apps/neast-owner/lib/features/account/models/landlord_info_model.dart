import 'package:freezed_annotation/freezed_annotation.dart';

// Freezed 工厂参数上的 @JsonKey 会触发 analyzer 误报，生成代码正常。
// ignore_for_file: invalid_annotation_target

part 'landlord_info_model.freezed.dart';
part 'landlord_info_model.g.dart';

@freezed
abstract class LandlordInfoModel with _$LandlordInfoModel {
  const LandlordInfoModel._();

  const factory LandlordInfoModel({
    @Default(0) int id,
    @Default('') String name,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name') @Default('') String lastName,
    @Default('') String phone,
    @Default('') String email,
    @JsonKey(name: 'bank_name') @Default('') String bankName,
    @JsonKey(name: 'bank_account') @Default('') String bankAccount,
    @JsonKey(name: 'account_holder_name') @Default('') String accountHolderName,
    @JsonKey(name: 'bank_header_photo') @Default('') String bankHeaderPhoto,
    @JsonKey(name: 'bank_header_photo_url') @Default('') String bankHeaderPhotoUrl,
    @Default(1) int status,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _LandlordInfoModel;

  factory LandlordInfoModel.fromJson(Map<String, dynamic> json) =>
      _$LandlordInfoModelFromJson(json);

  bool get hasBankAccount => bankAccount.trim().isNotEmpty;

  String get avatarInitials {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    }

    final parts =
        name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.elementAt(1)[0]}'.toUpperCase();
    }
    if (parts.isNotEmpty) {
      final word = parts.first;
      if (word.length >= 2) {
        return word.substring(0, 2).toUpperCase();
      }
      return word[0].toUpperCase();
    }
    if (phone.isNotEmpty) {
      return phone[0].toUpperCase();
    }
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return '?';
  }
}
