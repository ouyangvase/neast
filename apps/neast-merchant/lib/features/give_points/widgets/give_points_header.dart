import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/give_points/give_points_assets.dart';
import 'package:neast/features/give_points/give_points_colors.dart';

/// Give Points 页顶栏：背景图 + 商家头像与标题。
class GivePointsHeader extends ConsumerWidget {
  const GivePointsHeader({super.key});

  static const _headerAsset = GivePointsAssets.header;
  static const _imageAspectRatio = 510 / 1125;
  static const _avatarSize = 44.0;
  static const _nameTitleGap = 4.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandBlue = context.appColors.brandBlue;
    final merchant = ref.watch(merchantInfoProvider).value;
    final imageHeight = MediaQuery.sizeOf(context).width * _imageAspectRatio;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: GivePointsColors.background,
        child: SizedBox(
          height: imageHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _headerAsset,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: _avatarSize,
                          height: _avatarSize,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: brandBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                merchant?.avatarInitials ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                merchant?.name ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: _nameTitleGap),
                              const Text(
                                'Give Points',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'FD',
                                  fontVariations: [FontVariation('wght', 500)],
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
