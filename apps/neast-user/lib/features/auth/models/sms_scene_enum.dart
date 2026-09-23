/// 用户短信验证码发送场景的枚举
enum SmsSceneEnum {
  /// 会员用户 - 手机号登录
  memberLogin(1, "user-sms-login", "会员用户 - 手机号登录"),
  /// 会员用户 - 修改手机
  memberUpdateMobile(2, "user-update-mobile", "会员用户 - 修改手机"),
  /// 会员用户 - 修改密码
  memberUpdatePassword(3, "user-update-password", "会员用户 - 修改密码"),
  /// 会员用户 - 忘记密码
  memberResetPassword(4, "user-reset-password", "会员用户 - 忘记密码");

  const SmsSceneEnum(this.type, this.templateCode, this.description);

  /// 验证场景的编号
  final int type;
  /// 模板编码
  final String templateCode;
  /// 描述
  final String description;

  /// 根据场景编号获取枚举值
  static SmsSceneEnum? getByType(int type) {
    for (final typeEnum in SmsSceneEnum.values) {
      if (typeEnum.type == type) {
        return typeEnum;
      }
    }
    return null;
  }

  /// 获取所有场景编号数组
  static List<int> get allTypes => SmsSceneEnum.values.map((e) => e.type).toList();
} 