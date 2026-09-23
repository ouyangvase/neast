import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/coupon/models/coupon_category_model.dart';

/// 优惠券页分类 Tab 横向滚动条。
class CouponCategoryTabs extends StatelessWidget {
  const CouponCategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<CouponCategoryModel> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onSelected;

  static const _allLabel = 'All';

  bool get _isAllSelected => selectedCategoryId == null;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final tabCount = categories.length + 1;

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabCount,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _TabChip(
              label: _allLabel,
              isSelected: _isAllSelected,
              brandBlue: brandBlue,
              onTap: () => onSelected(null),
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategoryId == category.id;

          return _TabChip(
            label: category.name,
            isSelected: isSelected,
            brandBlue: brandBlue,
            onTap: () => onSelected(category.id),
          );
        },
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.brandBlue,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color brandBlue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? brandBlue : const Color(0xFFEAF2FA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : brandBlue,
          ),
        ),
      ),
    );
  }
}
