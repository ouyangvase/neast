import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:neast/core/constants/map_tile_config.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/providers/user_profile_provider.dart';
import 'package:neast/features/auth/services/auth_service.dart';
import 'package:neast/features/merchant/models/merchant_list_kind.dart';
import 'package:neast/features/merchant/models/merchant_model.dart';
import 'package:neast/features/merchant/providers/merchant_map_provider.dart';
import 'package:neast/features/merchant/utils/merchant_map_actions.dart';
import 'package:neast/features/merchant/widgets/merchant_map_marker.dart';
import 'package:neast/features/notification/providers/notification_unread_provider.dart';

const _mapTopRadius = 22.0;

/// 商家地图页：分类筛选 + 附近商家地图 + Deals Near You 列表。
class MerchantMapScreen extends ConsumerStatefulWidget {
  const MerchantMapScreen({super.key});

  @override
  ConsumerState<MerchantMapScreen> createState() => _MerchantMapScreenState();
}

class _MerchantMapScreenState extends ConsumerState<MerchantMapScreen> {
  bool _listCollapsed = false;
  int? _selectedMerchantId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantMapProvider.notifier).initialize();
      if (!ref.read(isLoggedInProvider)) return;
      ref.read(notificationUnreadProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(merchantMapProvider);
    final brandBlue = context.appColors.brandBlue;
    final brandBlueLight = context.appColors.brandBlueLight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MerchantMapHeader(
              brandBlueLight: brandBlueLight,
              selectedCategoryId: mapState.selectedCategoryId,
              onCategorySelected: (categoryId) {
                ref.read(merchantMapProvider.notifier).selectCategory(categoryId);
              },
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final expandedSheetHeight = constraints.maxHeight / 2;

                  return ColoredBox(
                    color: brandBlueLight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: _MapClipContainer(
                            child: Stack(
                              children: [
                                _buildMapArea(mapState, brandBlue),
                                if (mapState.isLoading &&
                                    mapState.merchants.isEmpty)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: _listCollapsed
                                  ? null
                                  : expandedSheetHeight,
                              child: _DealsNearYouSection(
                                brandBlue: brandBlue,
                                isLoading: mapState.isLoading,
                                merchants: mapState.merchants,
                                selectedMerchantId: _selectedMerchantId,
                                selectedCategoryId: mapState.selectedCategoryId,
                                collapsed: _listCollapsed,
                                onToggleCollapse: () {
                                  setState(() {
                                    _listCollapsed = !_listCollapsed;
                                  });
                                },
                                onViewAll: _openMerchantList,
                                onMerchantTap: (merchant) {
                                  setState(() {
                                    _selectedMerchantId = merchant.id;
                                  });
                                },
                                onViewMerchant: _openMerchantDetail,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapArea(MerchantMapState mapState, Color brandBlue) {
    if (mapState.locationUnavailable) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            mapState.locationErrorMessage ??
                'Enable location to see nearby merchants',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: brandBlue.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    if (mapState.latitude == null || mapState.longitude == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final userPoint = LatLng(mapState.latitude!, mapState.longitude!);

    return _MerchantMapView(
      key: ValueKey(
        '${mapState.latitude!.toStringAsFixed(6)}_'
        '${mapState.longitude!.toStringAsFixed(6)}',
      ),
      center: userPoint,
      merchants: mapState.merchants,
      onMerchantTap: (merchant) {
        setState(() {
          _selectedMerchantId = merchant.id;
        });
      },
    );
  }

  void _openMerchantList() {
    context.push(
      AppRoutes.merchants(
        kind: MerchantListKind.nearby,
        headerTitle: MerchantListHeaderTitle.nearbyMerchants,
      ),
    );
  }

  void _openMerchantDetail(MerchantModel merchant) {
    context.push(AppRoutes.merchantDetail(merchant.id));
  }
}

/// 独立地图视图：避免列表 loading 等状态变化导致 [FlutterMap] 重建引发表计算异常。
class _MerchantMapView extends StatefulWidget {
  const _MerchantMapView({
    super.key,
    required this.center,
    required this.merchants,
    required this.onMerchantTap,
  });

  final LatLng center;
  final List<MerchantModel> merchants;
  final ValueChanged<MerchantModel> onMerchantTap;

  @override
  State<_MerchantMapView> createState() => _MerchantMapViewState();
}

class _MerchantMapViewState extends State<_MerchantMapView> {
  double? _initialZoom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }

        _initialZoom ??= MapTileConfig.zoomForRadiusKm(
          latitude: widget.center.latitude,
          radiusKm: 1,
          mapWidthPx: constraints.maxWidth,
        );

        return FlutterMap(
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: _initialZoom!,
            interactionOptions: MapTileConfig.interactionOptions,
          ),
          children: [
            MapTileConfig.buildOsmTileLayer(),
            MarkerLayer(markers: _buildMarkers()),
          ],
        );
      },
    );
  }

  List<Marker> _buildMarkers() {
    final merchantMarkers = widget.merchants
        .where((merchant) =>
            merchant.latitude != null && merchant.longitude != null)
        .map(
          (merchant) => MerchantMapMarker.buildMarker(
            merchant: merchant,
            onTap: () => widget.onMerchantTap(merchant),
          ),
        )
        .toList();

    return [
      UserLocationMarker.buildMarker(point: widget.center),
      ...merchantMarkers,
    ];
  }

}

/// 地图裁剪容器：顶部 22 圆角，圆角外露出品牌浅蓝底色。
class _MapClipContainer extends StatelessWidget {
  const _MapClipContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_mapTopRadius),
        ),
      ),
      child: child,
    );
  }
}

class _MerchantMapHeader extends ConsumerStatefulWidget {
  const _MerchantMapHeader({
    required this.brandBlueLight,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final Color brandBlueLight;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategorySelected;

  @override
  ConsumerState<_MerchantMapHeader> createState() => _MerchantMapHeaderState();
}

class _MerchantMapHeaderState extends ConsumerState<_MerchantMapHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onLoginRequiredTap() {
    context.push(AppRoutes.login);
  }

  Future<void> _onQrTap() async {
    var profile = ref.read(userProfileProvider).value;
    if (profile == null) {
      await ref.read(userProfileProvider.notifier).fetchIfNeeded();
      profile = ref.read(userProfileProvider).value;
    }

    if (!mounted || profile == null || profile.qrCode.isEmpty) return;

    context.push(AppRoutes.myQr);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final chipsAsync = ref.watch(merchantMapCategoryChipsProvider);
    final brandBlueLight = widget.brandBlueLight;

    return ColoredBox(
      color: const Color(0xFF0A2A55),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color(0xFF3D6CB0),
                BlendMode.multiply,
              ),
              child: Image.asset(
                'assets/images/home/home_bg.png',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Nearby Deals',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'FD',
                              fontVariations: [FontVariation('wght', 700)],
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _buildNotificationButton(),
                        const SizedBox(width: 12),
                        _buildQrButton(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'HG',
                        color: Colors.black,
                      ),
                      cursorColor: brandBlueLight,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search nearby merchants',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          fontFamily: 'HG',
                          color: brandBlueLight.withValues(alpha: 0.55),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: brandBlueLight.withValues(alpha: 0.75),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.92),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: chipsAsync.when(
                    loading: () => const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (chips) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 5),
                      child: Row(
                        children: [
                          for (var i = 0; i < chips.length; i++) ...[
                            if (i > 0) const SizedBox(width: 8),
                            _CategoryChip(
                              label: chips[i].label,
                              isSelected: chips[i].isAll
                                  ? widget.selectedCategoryId == null
                                  : widget.selectedCategoryId ==
                                      chips[i].categoryId,
                              isPointsDeal: chips[i].isPointsDeal,
                              brandBlueLight: brandBlueLight,
                              onTap: () => widget
                                  .onCategorySelected(chips[i].categoryId),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrButton() {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return GestureDetector(
      onTap: isLoggedIn ? _onQrTap : _onLoginRequiredTap,
      behavior: HitTestBehavior.opaque,
      child: const SizedBox(
        width: 36,
        height: 36,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFF052E6B),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.qr_code_scanner,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final hasUnread = ref.watch(notificationUnreadProvider).value ?? false;

    return GestureDetector(
      onTap: isLoggedIn
          ? () => context.push(AppRoutes.notification)
          : _onLoginRequiredTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFF052E6B),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          if (hasUnread)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.isPointsDeal,
    required this.brandBlueLight,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isPointsDeal;
  final Color brandBlueLight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = isPointsDeal ? const Color(0xFFB8860B) : brandBlueLight;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? accent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.white, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPointsDeal) ...[
              Icon(
                Icons.flash_on,
                size: 14,
                color: isSelected ? Colors.white : accent,
              ),
              const SizedBox(width: 2),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'HG',
                fontVariations: [
                  FontVariation('wght', isPointsDeal ? 700 : 500),
                ],
                color: isSelected ? Colors.white : accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealsNearYouSection extends StatelessWidget {
  const _DealsNearYouSection({
    required this.brandBlue,
    required this.isLoading,
    required this.merchants,
    required this.selectedMerchantId,
    required this.selectedCategoryId,
    required this.collapsed,
    required this.onToggleCollapse,
    required this.onViewAll,
    required this.onMerchantTap,
    required this.onViewMerchant,
  });

  final Color brandBlue;
  final bool isLoading;
  final List<MerchantModel> merchants;
  final int? selectedMerchantId;
  final int? selectedCategoryId;
  final bool collapsed;
  final VoidCallback onToggleCollapse;
  final VoidCallback onViewAll;
  final ValueChanged<MerchantModel> onMerchantTap;
  final ValueChanged<MerchantModel> onViewMerchant;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: const Color(0x14000000),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      child: Column(
        mainAxisSize: collapsed ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onToggleCollapse,
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                  child: Center(
                    child: SizedBox(
                      width: 36,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFC7C7C7),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    collapsed
                        ? MediaQuery.paddingOf(context).bottom + 24
                        : 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deals Near You',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'HG',
                                fontVariations: [FontVariation('wght', 700)],
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Showing top deals within 1km',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'HG',
                                fontVariations: [FontVariation('wght', 400)],
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onViewAll,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'HG',
                                fontVariations: [FontVariation('wght', 700)],
                                color: brandBlue,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD6E6FA),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF9CC4F0),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                size: 14,
                                color: brandBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!collapsed)
            Expanded(
              child: _buildList(),
            ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (isLoading && merchants.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (merchants.isEmpty) {
      return Center(
        child: Text(
          'No nearby merchants',
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'HG',
            fontVariations: [FontVariation('wght', 400)],
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: merchants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final merchant = merchants[index];
        return _MapNearbyMerchantTile(
          merchant: merchant,
          isSelected: selectedMerchantId == merchant.id,
          showPointsDealHighlight:
              selectedCategoryId == 5 &&
              index == 0 &&
              selectedMerchantId == merchant.id,
          onTap: () => onMerchantTap(merchant),
          onView: () => onViewMerchant(merchant),
          onGetDirection: () => openMerchantInGoogleMaps(
            address: merchant.address,
            latitude: merchant.latitude,
            longitude: merchant.longitude,
          ),
        );
      },
    );
  }
}

class _MapNearbyMerchantTile extends StatelessWidget {
  const _MapNearbyMerchantTile({
    required this.merchant,
    required this.isSelected,
    required this.showPointsDealHighlight,
    required this.onTap,
    required this.onView,
    required this.onGetDirection,
  });

  static const _borderColor = Color(0xFFEEEEEE);

  final MerchantModel merchant;
  final bool isSelected;
  final bool showPointsDealHighlight;
  final VoidCallback onTap;
  final VoidCallback onView;
  final VoidCallback onGetDirection;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final address = merchant.address.trim();
    final shortAddress = address.contains(',')
        ? address.split(',').last.trim()
        : address;
    final distanceText = merchant.shortDistanceLabel.isNotEmpty
        ? merchant.shortDistanceLabel
        : merchant.distanceLabel;
    final metaParts = [
      if (distanceText.isNotEmpty) distanceText,
      if (shortAddress.isNotEmpty) shortAddress,
    ];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: showPointsDealHighlight
              ? const Color(0xFFFFFCF4)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: showPointsDealHighlight
                ? const Color(0xFFB8860B)
                : isSelected
                    ? brandBlue
                    : _borderColor,
            width: 1,
          ),
        ),
        child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 78,
                  height: 78,
                  child: _buildAvatar(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showPointsDealHighlight) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5AB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flash_on,
                              size: 10,
                              color: Color(0xFFB8860B),
                            ),
                            SizedBox(width: 1),
                            Text(
                              '5X POINTS DEAL',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'HG',
                                fontVariations: [FontVariation('wght', 700)],
                                color: Color(0xFFB8860B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                    ],
                    Text(
                      merchant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'HG',
                        fontVariations: [FontVariation('wght', 700)],
                        color: Colors.black,
                      ),
                    ),
                    if (metaParts.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        metaParts.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 400)],
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                    if (merchant.specialDeal.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        merchant.specialDeal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 800)],
                          color: brandBlue,
                        ),
                      ),
                    ],
                    if (merchant.minSpend.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Min. spend RM${merchant.minSpend}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 400)],
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Center(
                child: GestureDetector(
                  onTap: isSelected ? onGetDirection : onView,
                  behavior: HitTestBehavior.opaque,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 92),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: brandBlue),
                      ),
                      child: Text(
                        isSelected ? 'Get Direction' : 'View',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 800)],
                          color: brandBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: brandBlue.withValues(alpha: 0.5),
              ),
            ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (merchant.image.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: merchant.image,
        fit: BoxFit.cover,
        placeholder: (_, __) => _placeholderAvatar(),
        errorWidget: (_, __, ___) => _placeholderAvatar(),
      );
    }

    return _placeholderAvatar();
  }

  Widget _placeholderAvatar() {
    return ColoredBox(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.storefront_outlined, color: Colors.grey, size: 26),
      ),
    );
  }
}
