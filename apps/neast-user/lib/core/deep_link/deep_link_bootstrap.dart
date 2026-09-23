import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/deep_link/deep_link_service.dart';

/// 初始化 App 深链监听。
class DeepLinkBootstrap extends ConsumerStatefulWidget {
  const DeepLinkBootstrap({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<DeepLinkBootstrap> createState() => _DeepLinkBootstrapState();
}

class _DeepLinkBootstrapState extends ConsumerState<DeepLinkBootstrap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deepLinkServiceProvider).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
