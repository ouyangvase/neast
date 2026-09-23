import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast_landlords/core/constants/app_constants.dart';
import 'package:neast_landlords/core/utils/toast_util.dart';
import 'package:neast_landlords/features/properties/models/property_model.dart';
import 'package:url_launcher/url_launcher.dart';

const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'};

String resolvePropertyFileUrl(PropertyModel property) {
  final file = property.file.trim();
  if (file.isEmpty) return '';
  if (file.startsWith('http://') || file.startsWith('https://')) {
    return file;
  }
  final base = AppConstants.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
  return file.startsWith('/') ? '$base$file' : '$base/$file';
}

String resolvePropertyImageUrl(PropertyModel property) {
  final image = property.image.trim();
  if (image.isEmpty) return '';
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return image;
  }
  final base = AppConstants.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
  return image.startsWith('/') ? '$base$image' : '$base/$image';
}

bool _isImageUrl(String url) {
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  final dot = path.lastIndexOf('.');
  if (dot < 0) return false;
  return _imageExtensions.contains(path.substring(dot + 1));
}

Future<void> openRemoteFileUrl(BuildContext context, String url) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) {
    ToastUtil.show('File is not available');
    return;
  }

  if (_isImageUrl(trimmed)) {
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
                    imageUrl: trimmed,
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

  final uri = Uri.tryParse(trimmed);
  if (uri == null) {
    ToastUtil.show('Invalid file URL');
    return;
  }

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    ToastUtil.show('Unable to open file');
  }
}

Future<void> openPropertyFile(
  BuildContext context,
  PropertyModel property,
) async {
  await openRemoteFileUrl(context, resolvePropertyFileUrl(property));
}
