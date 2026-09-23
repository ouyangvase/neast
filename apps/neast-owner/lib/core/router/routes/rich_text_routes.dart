import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/rich_text/pages/rich_text_screen.dart';

final List<GoRoute> richTextRoutes = [
  GoRoute(
    path: AppRoutes.richText,
    name: 'richText',
    builder: (context, state) {
      final title = state.extra as String? ?? '';
      return RichTextScreen(title: title);
    },
  ),
];
