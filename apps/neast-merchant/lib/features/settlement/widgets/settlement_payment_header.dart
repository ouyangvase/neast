import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/settlement/settlement_assets.dart';
import 'package:neast/features/settlement/settlement_colors.dart';

/// 支付页顶栏：背景图 + 返回 + 居中标题。
class SettlementPaymentHeader extends StatelessWidget {
  const SettlementPaymentHeader({super.key});

  static const _imageAspectRatio = 510 / 1125;

  static double imageHeightOf(BuildContext context) {
    return MediaQuery.sizeOf(context).width * _imageAspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = imageHeightOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: SettlementColors.background,
        child: SizedBox(
          height: imageHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                SettlementAssets.header,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => context.pop(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 23,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'Settlement',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'FD',
                            fontVariations: [FontVariation('wght', 500)],
                            color: context.appColors.brandBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
