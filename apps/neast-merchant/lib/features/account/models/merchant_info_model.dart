import 'package:freezed_annotation/freezed_annotation.dart';

// Freezed 工厂参数上的 @JsonKey 会触发 analyzer 误报，生成代码正常。
// ignore_for_file: invalid_annotation_target

part 'merchant_info_model.freezed.dart';
part 'merchant_info_model.g.dart';

String _readDecimalString(Object? value) => value?.toString() ?? '0.00';

@freezed
abstract class MerchantInfoModel with _$MerchantInfoModel {
  const MerchantInfoModel._();

  const factory MerchantInfoModel({
    @Default(0) int id,
    @Default('') String name,
    @Default('') String address,
    @Default('') String image,
    @Default('') String email,
    @Default('') String phone,
    @JsonKey(name: 'contact_name') @Default('') String contactName,
    @JsonKey(name: 'contact_phone') @Default('') String contactPhone,
    @JsonKey(name: 'contact_email') @Default('') String contactEmail,
    @JsonKey(fromJson: _readDecimalString) @Default('0.00') String balance,
    @Default(1) int status,
    String? latitude,
    String? longitude,
    @JsonKey(name: 'registration_number')
    @Default('')
    String registrationNumber,
  }) = _MerchantInfoModel;

  factory MerchantInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantInfoModelFromJson(json);

  String get avatarInitials {
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
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return '?';
  }

  String get avatarLetter {
    if (name.trim().isNotEmpty) {
      return name.trim()[0].toUpperCase();
    }
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return '?';
  }
}
