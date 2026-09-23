import 'package:flutter/material.dart';
import 'package:neast/features/account/widgets/account_header.dart';
import 'package:neast/features/account/widgets/account_menu_list.dart';

/// Account 主页面。
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF2F9FC),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountHeader(),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: AccountMenuList(),
            ),
          ],
        ),
      ),
    );
  }
}
