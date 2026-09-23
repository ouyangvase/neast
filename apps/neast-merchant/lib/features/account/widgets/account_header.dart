import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neast/features/account/account_assets.dart';
import 'package:neast/features/account/widgets/account_balance_card.dart';
import 'package:neast/features/account/widgets/account_profile_card.dart';

/// Account 页面头部：顶部背景图 + 商家信息卡 + 余额卡（余额卡下半部分延伸出背景）。
class AccountHeader extends StatelessWidget {
  const AccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final backgroundHeight = screenWidth * 170 / 375;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: backgroundHeight,
            child: Image.asset(
              AccountAssets.header,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: AccountProfileCard(),
                ),
              ),
              const SizedBox(height: 14),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: AccountBalanceCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
