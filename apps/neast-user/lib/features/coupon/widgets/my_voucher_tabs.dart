import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';

/// 我的优惠券页 Tab 切换栏（TabBar 滑动指示器，与 TabBarView 联动）。
class MyVoucherTabs extends StatelessWidget {
  const MyVoucherTabs({
    super.key,
    required this.controller,
  });

  static const _tabBackground = Color(0xFFF4F5F9);
  static const _outerRadius = 26.0;
  static const _innerRadius = 26.0;
  static const _barPadding = 0.0;
  static const _itemHeight = 46.0;

  final TabController controller;

  static const _tabs = [
    (MyVoucherStatus.active, 'Active'),
    (MyVoucherStatus.used, 'Used'),
    (MyVoucherStatus.expired, 'Expired'),
  ];

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(_barPadding),
        decoration: BoxDecoration(
          color: _tabBackground,
          borderRadius: BorderRadius.circular(_outerRadius),
        ),
        child: SizedBox(
          height: _itemHeight,
          child: TabBar(
            controller: controller,
            tabAlignment: TabAlignment.fill,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: brandBlueLight,
              borderRadius: BorderRadius.circular(_innerRadius),
            ),
            dividerColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            labelColor: Colors.white,
            unselectedLabelColor: brandBlue,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 600)],
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 600)],
            ),
            labelPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            tabs: [
              for (final tab in _tabs) Tab(text: tab.$2),
            ],
          ),
        ),
      ),
    );
  }
}

String myVoucherSectionTitle(MyVoucherStatus status) => switch (status) {
      MyVoucherStatus.active => 'Active Vouchers',
      MyVoucherStatus.used => 'Used Vouchers',
      MyVoucherStatus.expired => 'Expired Vouchers',
    };

String myVoucherEmptyText(MyVoucherStatus status) => switch (status) {
      MyVoucherStatus.active => 'No active vouchers',
      MyVoucherStatus.used => 'No used vouchers',
      MyVoucherStatus.expired => 'No expired vouchers',
    };
