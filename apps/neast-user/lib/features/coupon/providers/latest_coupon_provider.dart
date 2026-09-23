import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/coupon/models/coupon_model.dart';
import 'package:neast/features/coupon/services/coupon_service.dart';

/// 首页 Featured 最新优惠券。
final latestCouponProvider = FutureProvider<CouponModel?>((ref) {
  return ref.read(couponServiceProvider).fetchLatest();
});
