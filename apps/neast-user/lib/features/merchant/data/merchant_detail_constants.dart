import 'package:flutter/material.dart';

/// 商家详情页固定展示文案与样式。
abstract final class MerchantDetailConstants {
  static const icon = Icons.storefront_outlined;
  static const iconColor = Color(0xFF0851AA);

  static const earnSteps = [
    'make a purchase at any outlet',
    'Present the QR code to the merchant for verification',
    'Merchant verification grants points',
    'points credited within 24 hours',
  ];
}
