import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/core/widgets/app_refresher.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';
import 'package:neast_landlords/features/account/widgets/bank_detail_required_dialog.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/widgets/ack_list_header.dart';
import 'package:neast_landlords/features/properties/providers/property_list_provider.dart';
import 'package:neast_landlords/features/properties/utils/property_file_actions.dart';
import 'package:neast_landlords/features/properties/widgets/property_list_card.dart';
import 'package:neast_landlords/features/properties/widgets/property_qrcode_dialog.dart';

/// 物业列表页。
class PropertiesScreen extends ConsumerStatefulWidget {
  const PropertiesScreen({super.key});

  @override
  ConsumerState<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends ConsumerState<PropertiesScreen> {
  late final EasyRefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(propertyListProvider.notifier).initialLoad();
      ref.read(landlordInfoProvider.notifier).fetchIfNeeded();
    });
  }

  Future<void> _onCreateTap() async {
    await EasyLoading.show();
    try {
      await ref.read(landlordInfoProvider.notifier).refresh();
    } finally {
      await EasyLoading.dismiss();
    }

    if (!mounted) {
      return;
    }

    final info = ref.read(landlordInfoProvider).value;

    if (info == null || !info.hasBankAccount) {
      await BankDetailRequiredDialog.show(
        onGoToBankDetail: () => context.push(AppRoutes.bankDetail),
      );
      return;
    }

    context.push(AppRoutes.addProperty);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final listState = ref.watch(propertyListProvider);
    final total = ref.watch(propertyListTotalProvider);
    final displayTotal = total > 0 ? total : listState.list.length;

    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AckListHeader(
            title: 'Properties',
            showBackButton: false,
            trailing: GestureDetector(
              onTap: _onCreateTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: brandBlue.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 500)],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Properties ($displayTotal)',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'HG',
                fontVariations: [FontVariation('wght', 500)],
                color: brandBlue,
              ),
            ),
          ),
          Expanded(
            child: AppRefresher(
              controller: _refreshController,
              onRefresh: () =>
                  ref.read(propertyListProvider.notifier).refresh(),
              onLoad: () async {
                await ref.read(propertyListProvider.notifier).loadMore();
                return ref.read(propertyListProvider).hasMore;
              },
              child: listState.isLoading && listState.list.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 120),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : listState.list.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(
                              child: Text(
                                'No properties yet',
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
                          itemCount: listState.list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = listState.list[index];
                            return PropertyListCard(
                              item: item,
                              onQrcodeTap: item.sn.isNotEmpty
                                  ? () => PropertyQrcodeDialog.show(
                                        sn: item.sn,
                                        propertyName: item.name,
                                      )
                                  : null,
                              onDocumentTap: () =>
                                  openPropertyFile(context, item),
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
