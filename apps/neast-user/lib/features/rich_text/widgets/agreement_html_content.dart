import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:neast/core/theme/app_colors.dart';

/// 协议 HTML 正文展示。
class AgreementHtmlContent extends StatelessWidget {
  const AgreementHtmlContent({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Html(
      data: content,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(14),
          lineHeight: const LineHeight(1.6),
          color: brandBlue,
        ),
        'p': Style(margin: Margins.only(bottom: 8)),
        'a': Style(color: brandBlue),
      },
    );
  }
}
