import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';
import 'package:neast_landlords/features/home/home_assets.dart';
import 'package:neast_landlords/features/home/home_colors.dart';
import 'package:neast_landlords/features/home/models/rent_item_model.dart';
import 'package:neast_landlords/features/home/widgets/home_avatar.dart';
import 'package:neast_landlords/features/properties/utils/property_file_actions.dart';

/// 租金详情页。
class RentDetailScreen extends StatelessWidget {
  const RentDetailScreen({super.key, required this.item});

  final RentItemModel item;

  static const _headerAspectRatio = 375 / 133;
  static const _cardOverlap = 24.0;
  static const _dueSoonStatusColor = Color(0xFFE3A86D);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: HomeColors.background,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _headerAspectRatio,
                          child: Image.asset(
                            HomeAssets.houseEg,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SafeArea(
                            bottom: false,
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, -_cardOverlap),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _PropertyDetailCard(
                          item: item,
                          onAgreementTap: () =>
                              openRemoteFileUrl(context, item.fileUrl),
                        ),
                      ),
                    ),
                    SizedBox(height: 24 - _cardOverlap),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding + 16),
              child: GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: HomeColors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        HomeAssets.whatsappIcon,
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Whatsapp',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HG',
                          fontVariations: [FontVariation('wght', 500)],
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyDetailCard extends StatelessWidget {
  const _PropertyDetailCard({
    required this.item,
    this.onAgreementTap,
  });

  final RentItemModel item;
  final VoidCallback? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.propertyName,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 600)],
                    color: brandBlue,
                  ),
                ),
              ),
              if (item.isOverdue)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: HomeColors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'OVERDUE',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'HG',
                      fontVariations: [FontVariation('wght', 400)],
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: HomeColors.label,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.propertyAddress,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'HG',
                    fontVariations: [FontVariation('wght', 400)],
                    color: HomeColors.label,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Rental date: ${item.rentalDate}',
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'HG',
              fontVariations: [FontVariation('wght', 400)],
              color: HomeColors.label,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: HomeColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: item.isOverdue
                ? _OverdueTenantSection(
                    item: item,
                    brandBlue: brandBlue,
                    onAgreementTap: onAgreementTap,
                  )
                : _DueSoonTenantSection(
                    item: item,
                    brandBlue: brandBlue,
                    onAgreementTap: onAgreementTap,
                  ),
          ),
        ],
      ),
    );
  }
}

class _OverdueTenantSection extends StatelessWidget {
  const _OverdueTenantSection({
    required this.item,
    required this.brandBlue,
    this.onAgreementTap,
  });

  final RentItemModel item;
  final Color brandBlue;
  final VoidCallback? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeAvatar(initials: item.initials),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.address,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 400)],
                  color: HomeColors.label,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 13,
                    color: HomeColors.label,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.statusText,
                    style: const TextStyle(
                      fontSize: 10,
                      color: HomeColors.label,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RM ${item.amount}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'FD',
                      fontVariations: [FontVariation('wght', 500)],
                      color: HomeColors.orange,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onAgreementTap,
                    behavior: HitTestBehavior.opaque,
                    child: Image.asset(
                      HomeAssets.agreementCircle,
                      width: 22,
                      height: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DueSoonTenantSection extends StatelessWidget {
  const _DueSoonTenantSection({
    required this.item,
    required this.brandBlue,
    this.onAgreementTap,
  });

  final RentItemModel item;
  final Color brandBlue;
  final VoidCallback? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeAvatar(initials: item.initials),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 500)],
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.address,
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 400)],
                  color: HomeColors.label,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'RM ${item.amount}',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'FD',
                  fontVariations: [FontVariation('wght', 500)],
                  color: brandBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.statusText,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'HG',
                  fontVariations: [FontVariation('wght', 400)],
                  color: RentDetailScreen._dueSoonStatusColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: GestureDetector(
            onTap: onAgreementTap,
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              HomeAssets.agreementCircle,
              width: 22,
              height: 22,
            ),
          ),
        ),
      ],
    );
  }
}
