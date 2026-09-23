import 'package:flutter/material.dart';

/// Pay Rent 主页卡片阴影：`0 0 10px rgba(0,0,0,0.15)`。
abstract final class PayRentCardShadow {
  static const List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 10,
    ),
  ];
}
