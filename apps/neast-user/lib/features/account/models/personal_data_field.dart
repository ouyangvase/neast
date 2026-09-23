/// 个人资料单项编辑字段。
enum PersonalDataField {
  firstName,
  lastName,
  email,
  validUntil,
  address,
}

extension PersonalDataFieldX on PersonalDataField {
  String get title {
    switch (this) {
      case PersonalDataField.firstName:
        return 'First name';
      case PersonalDataField.lastName:
        return 'Last name';
      case PersonalDataField.email:
        return 'Email';
      case PersonalDataField.validUntil:
        return 'Valid until';
      case PersonalDataField.address:
        return 'Current address';
    }
  }
}
