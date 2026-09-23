import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neast_landlords/core/theme/app_colors.dart';

/// 租客首字母头像。
class HomeAvatar extends StatelessWidget {
  const HomeAvatar({
    super.key,
    required this.initials,
    this.size = 40,
    this.imageUrl,
  });

  final String initials;
  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;
    final url = imageUrl?.trim() ?? '';

    if (url.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => _InitialsAvatar(
            initials: initials,
            size: size,
            color: brandBlue,
          ),
          errorWidget: (_, __, ___) => _InitialsAvatar(
            initials: initials,
            size: size,
            color: brandBlue,
          ),
        ),
      );
    }

    return _InitialsAvatar(
      initials: initials,
      size: size,
      color: brandBlue,
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({
    required this.initials,
    required this.size,
    required this.color,
  });

  final String initials;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.34,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
