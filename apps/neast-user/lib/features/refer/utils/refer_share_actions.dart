import 'package:neast/core/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> shareInviteViaWhatsapp(String inviteUrl) async {
  final url = inviteUrl.trim();
  if (url.isEmpty) {
    ToastUtil.show('Invite link is not available');
    return;
  }

  final uri = Uri.parse(
    'https://wa.me/?text=${Uri.encodeComponent(url)}',
  );

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    ToastUtil.show('Unable to open WhatsApp');
  }
}
