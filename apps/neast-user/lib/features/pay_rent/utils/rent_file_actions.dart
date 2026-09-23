import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast/core/constants/app_constants.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:url_launcher/url_launcher.dart';

const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'};

String resolveRentFileUrl(RentModel rent) {
  if (rent.fileUrl.isNotEmpty) {
    return rent.fileUrl;
  }
  final file = rent.file.trim();
  if (file.isEmpty) return '';
  if (file.startsWith('http://') || file.startsWith('https://')) {
    return file;
  }
  final base = AppConstants.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
  return file.startsWith('/') ? '$base$file' : '$base/$file';
}

bool _isImageUrl(String url) {
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  final dot = path.lastIndexOf('.');
  if (dot < 0) return false;
  return _imageExtensions.contains(path.substring(dot + 1));
}

Future<void> openRentAgreementFile(
  BuildContext context,
  RentModel rent,
) async {
  final url = resolveRentFileUrl(rent);
  if (url.isEmpty) {
    ToastUtil.show('File is not available');
    return;
  }

  if (_isImageUrl(url)) {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.6,
                    maxWidth: MediaQuery.sizeOf(dialogContext).width - 48,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const SizedBox(
                      width: 120,
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return;
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    ToastUtil.show('Invalid file URL');
    return;
  }

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    ToastUtil.show('Unable to open file');
  }
}

String rentStatusLabel(int status) {
  switch (status) {
    case RentStatus.approved:
      return 'Approved';
    case RentStatus.rejected:
      return 'Rejected';
    case RentStatus.pendingBind:
      return 'Pending Bind';
    case RentStatus.pending:
      return 'Pending Review';
    default:
      return 'Pending Review';
  }
}

Color rentStatusColor(int status, Color brandBlue) {
  switch (status) {
    case RentStatus.approved:
      return const Color(0xFF2EAF7D);
    case RentStatus.rejected:
      return const Color(0xFFFF4444);
    case RentStatus.pendingBind:
      return brandBlue;
    case RentStatus.pending:
      return const Color(0xFFD4A853);
    default:
      return const Color(0xFFD4A853);
  }
}

/// 卡片状态 tag：仅待审核 / 待绑定 / 审核驳回展示；审核通过返回 null。
({String label, Color color})? rentStatusTag(int status, Color brandBlue) {
  switch (status) {
    case RentStatus.pending:
      return (
        label: 'Pending Review',
        color: const Color(0xFFD4A853),
      );
    case RentStatus.pendingBind:
      return (
        label: 'Pending Bind',
        color: brandBlue,
      );
    case RentStatus.rejected:
      return (
        label: 'Rejected',
        color: const Color(0xFFFF4444),
      );
    default:
      return null;
  }
}

String formatRentAmount(String amount) {
  final value = double.tryParse(amount);
  if (value == null) return 'RM$amount';
  final formatted = value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  return 'RM${_addThousandsSeparator(formatted)}';
}

String _addThousandsSeparator(String text) {
  final parts = text.split('.');
  final intPart = parts[0].replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );
  if (parts.length == 1) return intPart;
  return '$intPart.${parts[1]}';
}

String formatRentExpireDate(String expireDate) {
  if (expireDate.isEmpty) return '';
  try {
    final parts = expireDate.split('-');
    if (parts.length != 3) return expireDate;
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  } catch (_) {
    return expireDate;
  }
}

extension RentModelDisplay on RentModel {
  Color statusColor(BuildContext context) =>
      rentStatusColor(status, context.appColors.brandBlue);

  ({String label, Color color})? statusTag(BuildContext context) =>
      rentStatusTag(status, context.appColors.brandBlue);
}
