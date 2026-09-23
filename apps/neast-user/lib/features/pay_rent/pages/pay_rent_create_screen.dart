import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/features/pay_rent/providers/pay_rent_provider.dart';
import 'package:neast/features/pay_rent/widgets/pay_rent_form_card.dart';

/// 创建租金页面：表单上提叠入顶栏，保存成功后返回列表。
class PayRentCreateScreen extends ConsumerStatefulWidget {
  const PayRentCreateScreen({super.key});

  @override
  ConsumerState<PayRentCreateScreen> createState() =>
      _PayRentCreateScreenState();
}

class _PayRentCreateScreenState extends ConsumerState<PayRentCreateScreen> {
  static const _contentTopRadius = 22.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(payRentProvider.notifier).create();
    });
  }

  void _onPop() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(payRentProvider.notifier).cancel();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: brandBlueLight,
          appBar: AppBar(
            backgroundColor: brandBlueLight,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              onPressed: _onPop,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Pay Rent',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'HG',
                color: Colors.white,
                fontVariations: [FontVariation('wght', 500)],
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(_contentTopRadius),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: PayRentFormCard(
                    onSaveSuccess: () => context.pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
