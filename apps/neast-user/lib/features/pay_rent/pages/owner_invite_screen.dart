import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/utils/notifier_utils.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_list_provider.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerInviteArgs {
  const OwnerInviteArgs({
    required this.history,
    this.ownerName = '',
  });

  final RentHistoryModel history;
  final String ownerName;
}

class OwnerInviteScreen extends ConsumerStatefulWidget {
  const OwnerInviteScreen({super.key, required this.args});

  final OwnerInviteArgs args;

  @override
  ConsumerState<OwnerInviteScreen> createState() => _OwnerInviteScreenState();
}

class _OwnerInviteScreenState extends ConsumerState<OwnerInviteScreen> {
  late final TextEditingController _nameController;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.args.ownerName.isNotEmpty
          ? widget.args.ownerName
          : widget.args.history.landlordName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _draft {
    final history = widget.args.history;
    return 'Hi ${_nameController.text.trim()}, I paid RM${history.amount} rent for ${history.displayTitle} via NEAST. The money is held until you join NEAST Owner and add your bank. Download the NEAST Owner app to claim it.';
  }

  Future<void> _saveInvite() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      ToastUtil.show('Enter owner name, email, and phone');
      return;
    }

    await EasyLoading.show();
    try {
      final ok = await ref.runGuarded(() async {
        await ref.read(rentServiceProvider).inviteOwner(
              rentId: widget.args.history.rentId,
              historyId: widget.args.history.id,
              name: name,
              email: email,
              phone: phone,
            );
        return true;
      });
      if (ok != true) return;
      ref.invalidate(payRentListProvider);
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<void> _onEmail() async {
    await _saveInvite();
    final uri = Uri(
      scheme: 'mailto',
      path: _emailController.text.trim(),
      queryParameters: {
        'subject': 'Join NEAST to receive your rent',
        'body': _draft,
      },
    );
    final launched = await launchUrl(uri);
    if (!launched) ToastUtil.show('Unable to open email');
  }

  Future<void> _onWhatsApp() async {
    await _saveInvite();
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse(
      'https://wa.me/$digits?text=${Uri.encodeComponent(_draft)}',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) ToastUtil.show('Unable to open WhatsApp');
  }

  @override
  Widget build(BuildContext context) {
    final brandBlue = context.appColors.brandBlue;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F9FC),
      appBar: AppBar(
        title: const Text('Invite owner'),
        backgroundColor: brandBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          const Text(
            'This payment is held by NEAST. Invite the owner to join and add a bank so they can receive it.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Owner name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onEmail,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Email'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onWhatsApp,
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('WhatsApp'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
