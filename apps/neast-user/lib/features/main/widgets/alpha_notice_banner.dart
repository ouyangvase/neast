import 'package:flutter/material.dart';

/// Alpha 版本顶部横幅，Main 四个 Tab 共用。
class AlphaNoticeBanner extends StatelessWidget {
  const AlphaNoticeBanner({super.key});

  static const _backgroundColor = Color(0xFFFFF9E6);
  static const _textColor = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return ColoredBox(
      color: _backgroundColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 8),
        child: SizedBox(
          width: double.infinity,
          child: const Text(
            "⚠ You're using an alpha build - bugs are expected.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }
}
