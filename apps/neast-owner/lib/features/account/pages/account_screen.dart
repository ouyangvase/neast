import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/account/providers/landlord_info_provider.dart';
import 'package:neast_landlords/features/account/widgets/account_header.dart';
import 'package:neast_landlords/features/account/widgets/account_operations_section.dart';
import 'package:neast_landlords/features/home/providers/home_dashboard_provider.dart';

/// Account 主页面。
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(landlordInfoProvider.notifier).fetchIfNeeded();
      ref.read(homeDashboardProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF6F9F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AccountHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: AccountOperationsSection(),
            ),
          ),
        ],
      ),
    );
  }
}
