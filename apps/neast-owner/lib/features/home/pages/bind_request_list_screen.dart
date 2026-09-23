import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/providers/bind_request_list_provider.dart';
import 'package:neast_landlords/features/home/widgets/ack_list_header.dart';
import 'package:neast_landlords/features/home/widgets/bind_request_card.dart';

/// 待绑定申请列表页。
class BindRequestListScreen extends ConsumerWidget {
  const BindRequestListScreen({super.key});

  static const _listOverlap = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(bindRequestListProvider);

    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AckListHeader(title: 'Pending Bind Requests'),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -_listOverlap),
              child: listAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(
                  child: Text(
                    'Failed to load bind requests',
                    style: TextStyle(fontSize: 14, color: HomeColors.label),
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No pending bind requests',
                        style: TextStyle(fontSize: 14, color: HomeColors.label),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return BindRequestCard(
                        item: item,
                        onTap: () => context.push(
                          AppRoutes.bindRequestDetail,
                          extra: item,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
