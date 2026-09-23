import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/rich_text/providers/agreement_content_provider.dart';
import 'package:neast/features/rich_text/widgets/agreement_html_content.dart';
import 'package:neast/features/rich_text/widgets/rich_text_header.dart';

/// 富文本展示页面，通过 [title] 展示标题与正文。
class RichTextScreen extends ConsumerStatefulWidget {
  const RichTextScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  ConsumerState<RichTextScreen> createState() => _RichTextScreenState();
}

class _RichTextScreenState extends ConsumerState<RichTextScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(agreementContentProvider(widget.title).notifier).silentRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(agreementContentProvider(widget.title));
    final model = contentState.hasValue ? contentState.value : null;
    final content = model?.content.trim() ?? '';
    final showLoading = contentState.isLoading && content.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F6),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichTextHeader(title: widget.title),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: showLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: content.isEmpty
                            ? const SizedBox.shrink()
                            : AgreementHtmlContent(content: content),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
