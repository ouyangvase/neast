import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/account/models/merchant_info_model.dart';
import 'package:neast/features/account/providers/merchant_info_provider.dart';
import 'package:neast/features/rich_text/widgets/rich_text_header.dart';

/// 店铺详情页：店铺信息卡 + 详细信息。
class StoreProfileScreen extends ConsumerWidget {
  const StoreProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchant = ref.watch(merchantInfoProvider).value;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RichTextHeader(title: 'Store Profile'),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StoreInfoCard(merchant: merchant),
                  const SizedBox(height: 16),
                  _StoreDetailCard(merchant: merchant),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 店铺信息卡：Logo + 名称。
class _StoreInfoCard extends StatelessWidget {
  const _StoreInfoCard({required this.merchant});

  final MerchantInfoModel? merchant;

  static const double _logoSize = 60;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final name = merchant?.name.trim().isNotEmpty == true ? merchant!.name : '-';
    final imageUrl = merchant?.image.trim() ?? '';
    final initials = merchant?.avatarInitials ?? '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLogo(brandBlue, imageUrl, initials),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: brandBlue,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(Color brandBlue, String imageUrl, String initials) {
    final fallback = Container(
      width: _logoSize,
      height: _logoSize,
      alignment: Alignment.center,
      color: brandBlue,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageUrl.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              width: _logoSize,
              height: _logoSize,
              fit: BoxFit.cover,
              placeholder: (_, __) => fallback,
              errorWidget: (_, __, ___) => fallback,
            )
          : fallback,
    );
  }
}

/// 店铺详细信息卡：地址、联系电话、邮箱等。
class _StoreDetailCard extends StatelessWidget {
  const _StoreDetailCard({required this.merchant});

  final MerchantInfoModel? merchant;

  @override
  Widget build(BuildContext context) {
    final rows = <({String label, String value})>[
      (label: 'Address', value: merchant?.address ?? ''),
      (label: 'Contact number', value: merchant?.phone ?? ''),
      (label: 'Email', value: merchant?.email ?? ''),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _DetailRow(
              label: rows[i].label,
              value: rows[i].value.trim().isNotEmpty ? rows[i].value : '-',
            ),
            if (i != rows.length - 1) const _DetailDivider(),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: brandBlue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: brandBlue.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  const _DetailDivider();

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    return Divider(
      height: 1,
      thickness: 1,
      color: brandBlue.withValues(alpha: 0.12),
    );
  }
}
