import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/widgets/home_card.dart';

class _QuickAction {
  const _QuickAction({
    required this.iconAsset,
    required this.label,
    this.route,
  });

  final String iconAsset;
  final String label;
  final String? route;
}

/// 快捷操作网格（3 列 × 2 行）。
class HomeQuickActionsSection extends StatelessWidget {
  const HomeQuickActionsSection({super.key});

  static const _actions = [
    _QuickAction(
      iconAsset: HomeAssets.quickActionAddProperty,
      label: 'Add Property',
      route: AppRoutes.addProperty,
    ),
    _QuickAction(
      iconAsset: HomeAssets.quickActionSendReminder,
      label: 'Send Reminder',
    ),
    _QuickAction(
      iconAsset: HomeAssets.quickActionAgreements,
      label: 'Agreements',
    ),
    _QuickAction(
      iconAsset: HomeAssets.quickActionMaintenance,
      label: 'Maintenance',
    ),
    _QuickAction(
      iconAsset: HomeAssets.quickActionExportReport,
      label: 'Export Report',
    ),
    _QuickAction(
      iconAsset: HomeAssets.quickActionRiskCenter,
      label: 'Risk Center',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisSpacing = 10.0;
            const mainAxisSpacing = 10.0;
            const labelGap = 8.0;
            const labelLineHeight = 12.0 * 1.2;

            final cellWidth =
                (constraints.maxWidth - crossAxisSpacing * 2) / 3;
            final iconWidth =
                cellWidth - _QuickActionTile._horizontalPadding * 2;
            final iconHeight = iconWidth / _QuickActionTile._iconAspectRatio;
            final cellHeight = _QuickActionTile._verticalPadding * 2 +
                iconHeight +
                labelGap +
                labelLineHeight * 2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: cellWidth / cellHeight,
              ),
              itemCount: _actions.length,
              itemBuilder: (context, index) {
                final action = _actions[index];
                return _QuickActionTile(
                  action: action,
                  onTap: action.route != null
                      ? () => context.push(action.route!)
                      : null,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.action,
    this.onTap,
  });

  final _QuickAction action;
  final VoidCallback? onTap;

  static const _iconAspectRatio = 72 / 76;
  static const _horizontalPadding = 8.0;
  static const _verticalPadding = 0.0;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: HomeCard(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: _iconAspectRatio,
              child: Image.asset(
                action.iconAsset,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'FD',
                fontVariations: [FontVariation('wght', 500)],
                color: brandBlue,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
