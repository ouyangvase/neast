import 'package:flutter/material.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 个人资料信息行。
class PersonalDataFieldRow extends StatelessWidget {
  const PersonalDataFieldRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.editable = true,
    this.onTap,
  });

  final String label;
  final String value;
  final bool showDivider;
  final bool editable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Column(
      children: [
        InkWell(
          onTap: editable ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: brandBlue.withValues(alpha: 0.5),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 4),
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.appColors.blackText,
                      ),
                    ),
                  ),
                ),
                if (editable)
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: brandBlue.withValues(alpha: 0.4),
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: brandBlue.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}
