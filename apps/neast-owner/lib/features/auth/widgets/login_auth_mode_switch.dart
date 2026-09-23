import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// 登录 / 注册切换（基于 [TabBar] 滑动指示器动画）。
class LoginAuthModeSwitch extends StatelessWidget {
  const LoginAuthModeSwitch({
    super.key,
    required this.controller,
  });

  final TabController controller;

  static const outerRadius = 12.0;
  static const innerRadius = 8.0;
  static const barPadding = 8.0;
  static const itemHeight = 38.0;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final blackText = context.appColors.blackText;

    return Container(
      padding: const EdgeInsets.all(barPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(outerRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SizedBox(
        height: itemHeight,
        child: TabBar(
          controller: controller,
          tabAlignment: TabAlignment.fill,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: brandBlue,
            borderRadius: BorderRadius.circular(innerRadius),
          ),
          dividerColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          labelColor: Colors.white,
          unselectedLabelColor: blackText,
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          tabs: const [
            Tab(text: 'Log in'),
            Tab(text: 'Sign up'),
          ],
        ),
      ),
    );
  }
}
