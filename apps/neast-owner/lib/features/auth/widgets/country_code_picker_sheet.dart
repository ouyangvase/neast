import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// 区号选择底部弹窗，仅展示区号文本（无国旗）。
class CountryCodePickerSheet extends StatelessWidget {
  const CountryCodePickerSheet({
    super.key,
    required this.codes,
    required this.selected,
  });

  final List<String> codes;
  final String selected;

  static Future<String?> show(
    BuildContext context, {
    required List<String> codes,
    required String selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => CountryCodePickerSheet(
        codes: codes,
        selected: selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Select country code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: brandBlue,
              ),
            ),
          ),
          for (final code in codes)
            ListTile(
              title: Text(
                code,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: code == selected ? brandBlue : const Color(0xFF0F172A),
                ),
              ),
              trailing: code == selected
                  ? Icon(Icons.check, color: brandBlue)
                  : null,
              onTap: () => Navigator.of(context).pop(code),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
