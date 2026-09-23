import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/widgets/app_refresher.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/providers/ack_list_provider.dart';
import 'package:neast_landlords/features/home/widgets/ack_card.dart';
import 'package:neast_landlords/features/home/widgets/ack_list_header.dart';

/// 待确认收款列表页。
class AckListScreen extends ConsumerWidget {
  const AckListScreen({super.key});

  static const _listOverlap = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(ackListProvider);
    final items = listAsync.value ?? const [];

    ref.listen(ackListProvider, (previous, next) {
      if (next.hasError && previous?.hasValue == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AckListHeader(title: 'Need Acknowledgement'),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -_listOverlap),
              child: AppRefresher(
                onRefresh: () => ref.read(ackListProvider.notifier).refresh(),
                child: listAsync.isLoading && items.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 120),
                          Center(child: CircularProgressIndicator()),
                        ],
                      )
                    : items.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'No acknowledgement pending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: HomeColors.label,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return AckCard(
                                item: item,
                                onTap: () => context.push(
                                  AppRoutes.ackDetail,
                                  extra: item,
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
