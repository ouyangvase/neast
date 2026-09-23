import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/providers/portfolio_detail_provider.dart';
import 'package:neast_landlords/features/home/widgets/ack_list_header.dart';
import 'package:neast_landlords/features/home/widgets/portfolio_snapshot_cards.dart';
import 'package:neast_landlords/features/properties/providers/property_list_provider.dart';
import 'package:neast_landlords/features/properties/utils/property_file_actions.dart';
import 'package:neast_landlords/features/properties/widgets/property_list_card.dart';

/// 资产概览详情页。
class PortfolioSnapshotScreen extends ConsumerStatefulWidget {
  const PortfolioSnapshotScreen({super.key});

  @override
  ConsumerState<PortfolioSnapshotScreen> createState() =>
      _PortfolioSnapshotScreenState();
}

class _PortfolioSnapshotScreenState
    extends ConsumerState<PortfolioSnapshotScreen> {
  static const _listOverlap = 20.0;
  static const _horizontalPadding = 16.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(propertyListProvider.notifier).initialLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final portfolioAsync = ref.watch(portfolioDetailProvider);
    final portfolio = portfolioAsync.value;
    final listState = ref.watch(propertyListProvider);
    final total = ref.watch(propertyListTotalProvider);
    final displayTotal = total > 0 ? total : listState.list.length;
    final tenantCount = portfolio?.tenantCount ?? portfolio?.tenants.length ?? 0;

    return Scaffold(
      backgroundColor: HomeColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AckListHeader(title: 'Portfolio Snapshot'),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -_listOverlap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding,
                    ),
                    child: PortfolioRentRollCard(
                      rentRoll: portfolio?.displayRentRoll ?? '0',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        _horizontalPadding,
                        0,
                        _horizontalPadding,
                        24,
                      ),
                      children: [
                        Text(
                          'Properties ($displayTotal)',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'HG',
                            fontVariations: [FontVariation('wght', 500)],
                            color: brandBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (listState.isLoading && listState.list.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (listState.list.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'No properties yet',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: HomeColors.label,
                                ),
                              ),
                            ),
                          )
                        else
                          for (var i = 0; i < listState.list.length; i++) ...[
                            if (i > 0) const SizedBox(height: 12),
                            PropertyListCard(
                              item: listState.list[i],
                              onDocumentTap: () =>
                                  openPropertyFile(context, listState.list[i]),
                            ),
                          ],
                        const SizedBox(height: 20),
                        Text(
                          'Tenants ($tenantCount)',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'HG',
                            fontVariations: [FontVariation('wght', 500)],
                            color: brandBlue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (portfolioAsync.isLoading && portfolio == null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (portfolio == null ||
                            portfolio.tenants.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'No tenants yet',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: HomeColors.label,
                                ),
                              ),
                            ),
                          )
                        else
                          for (var i = 0; i < portfolio.tenants.length; i++) ...[
                            if (i > 0) const SizedBox(height: 12),
                            PortfolioTenantCard(
                              item: portfolio.tenants[i],
                              onTap: () => context.push(
                                AppRoutes.portfolioTenantDetail,
                                extra: portfolio.tenants[i].id,
                              ),
                            ),
                          ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
