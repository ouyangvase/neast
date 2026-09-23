import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面不存在'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              '找不到路径: ${uri.path}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.main),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
} 