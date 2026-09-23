import 'package:neast/features/merchant/models/merchant_list_kind.dart';

/// 应用路由路径常量（按模块分区，与 [lib/core/router/routes/] 下各 *Routes 对应）
class AppRoutes {
  // ═══════════════════════════════════════════════════════════════════════════
  // Shell — 启动页、主框架
  // ═══════════════════════════════════════════════════════════════════════════
  static const String splash = '/splash'; // 启动页
  static const String main = '/'; // 主 Tab / 首页容器

  // ═══════════════════════════════════════════════════════════════════════════
  // Auth — 登录注册
  // ═══════════════════════════════════════════════════════════════════════════
  static const String login = '/login'; // 登录
  static const String register = '/register'; // 注册
  static const String verify = '/verify'; // 验证码
  static const String fullData = '/full-data'; // 填写个人资料

  // ═══════════════════════════════════════════════════════════════════════════
  // RichText — 富文本页
  // ═══════════════════════════════════════════════════════════════════════════
  static const String richText = '/rich-text'; // 富文本页

  // ═══════════════════════════════════════════════════════════════════════════
  // Notification — 消息通知
  // ═══════════════════════════════════════════════════════════════════════════
  static const String notification = '/notification'; // 消息通知

  // ═══════════════════════════════════════════════════════════════════════════
  // Account — 账户相关
  // ═══════════════════════════════════════════════════════════════════════════
  static const String personalData = '/personal-data'; // 个人资料
  static const String personalDataEdit = '/personal-data/edit'; // 编辑单项资料
  static const String myQr = '/account/my-qr'; // 我的二维码
  static const String tentScore = '/account/tent-score'; // Tent Score 评分页

  // ═══════════════════════════════════════════════════════════════════════════
  // Points — 积分
  // ═══════════════════════════════════════════════════════════════════════════
  static const String points = '/points'; // 积分页
  static const String pointsHistory = '/points/history'; // 积分收支流水

  // ═══════════════════════════════════════════════════════════════════════════
  // Reward — 奖励等级
  // ═══════════════════════════════════════════════════════════════════════════
  static const String rewardTier = '/reward/tier'; // 奖励等级页

  // ═══════════════════════════════════════════════════════════════════════════
  // Merchant — 商家详情
  // ═══════════════════════════════════════════════════════════════════════════
  static const String merchant = '/merchant/:id'; // 商家详情
  static String merchantDetail(int id) => '/merchant/$id';
  static const String merchantList = '/merchants'; // 商家列表
  static const String merchantMap = '/merchants/map'; // 商家地图
  static String merchantMapRoute() => merchantMap;
  static String merchants({
    required MerchantListKind kind,
    MerchantListHeaderTitle? headerTitle,
  }) {
    final params = <String, String>{'kind': kind.name};
    if (headerTitle != null) {
      params['header'] = headerTitle.name;
    }
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return '$merchantList?$query';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Coupon — 优惠券兑换
  // ═══════════════════════════════════════════════════════════════════════════
  static const String coupon = '/coupon'; // 优惠券兑换页
  static const String couponDetail = '/coupon/detail'; // 优惠券详情
  static const String myVouchers = '/coupon/my-vouchers'; // 我的优惠券

  // ═══════════════════════════════════════════════════════════════════════════
  // Wallet — 钱包充值
  // ═══════════════════════════════════════════════════════════════════════════
  static const String wallet = '/wallet'; // 钱包页
  static const String walletPayment = '/wallet/payment'; // 钱包付款页
  static const String payH5WebView = '/pay-h5-webview'; // Fiuu H5 支付 WebView

  // ═══════════════════════════════════════════════════════════════════════════
  // Pay Rent — 租金支付
  // ═══════════════════════════════════════════════════════════════════════════
  static const String payRentPayment = '/pay-rent/payment'; // 租金支付页
  static const String payRentCreate = '/pay-rent/create'; // 创建租金页
  static const String payRentDetail = '/pay-rent/detail'; // 租金详情页
  static const String rentHistory = '/pay-rent/history'; // 还款历史
  static const String rentHistoryDetail = '/pay-rent/history/detail'; // 还款详情
  static const String ownerInvite = '/pay-rent/invite-owner';

  // ═══════════════════════════════════════════════════════════════════════════
  // Scan — 扫码
  // ═══════════════════════════════════════════════════════════════════════════
  static const String scanner = '/scanner'; // 全屏扫码页

  // ═══════════════════════════════════════════════════════════════════════════
  // Refer — 推荐好友
  // ═══════════════════════════════════════════════════════════════════════════
  static const String refer = '/refer'; // 推荐页
}
