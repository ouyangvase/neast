import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_list_item_model.dart';
import 'package:neast/features/coupon/widgets/my_voucher_list_panel.dart';
import 'package:neast/features/coupon/widgets/my_voucher_tabs.dart';

/// 我的优惠券页（Active / Used / Expired 三 Tab）。
class MyVouchersScreen extends ConsumerStatefulWidget {
  const MyVouchersScreen({super.key});

  @override
  ConsumerState<MyVouchersScreen> createState() => _MyVouchersScreenState();
}

class _MyVouchersScreenState extends ConsumerState<MyVouchersScreen>
    with SingleTickerProviderStateMixin {
  static const _contentTopRadius = 22.0;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brandBlueLight,
        appBar: AppBar(
          backgroundColor: brandBlueLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'My Vouchers',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'FD',
              fontVariations: [FontVariation('wght', 400)],
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(_contentTopRadius),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyVoucherTabs(controller: _tabController),
                    Expanded(
                      child: ExtendedTabBarView(
                        controller: _tabController,
                        link: true,
                        cacheExtent: 1,
                        shouldIgnorePointerWhenScrolling: false,
                        physics: const ClampingScrollPhysics(),
                        children: const [
                          MyVoucherListPanel(status: MyVoucherStatus.active),
                          MyVoucherListPanel(status: MyVoucherStatus.used),
                          MyVoucherListPanel(status: MyVoucherStatus.expired),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
