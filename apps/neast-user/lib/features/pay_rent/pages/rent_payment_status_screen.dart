import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/theme/app_colors.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/pages/owner_invite_screen.dart';

/// 还款历史付款详情页。
class RentPaymentStatusScreen extends StatelessWidget {
  const RentPaymentStatusScreen({super.key, required this.item});

  final RentHistoryModel item;

  static const _contentTopRadius = 22.0;
  static const _successGreen = Color(0xFF039414);

  @override
  Widget build(BuildContext context) {
    final brandBlueLight = context.appColors.brandBlueLight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Payment Status',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'FD',
              color: Colors.white,
              fontVariations: [FontVariation('wght', 400)],
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/pay_rent/success.svg',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Payment Successful!',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'FD',
                          fontVariations: [FontVariation('wght', 500)],
                          color: _successGreen,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAF8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              item.displayAmount,
                              style: const TextStyle(
                                fontSize: 30,
                                fontFamily: 'FD',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF12641C),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Paid on ${item.paidOnLabel}',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'HG',
                                fontVariations: [FontVariation('wght', 400)],
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _DetailRow(
                        label: 'Property',
                        value: item.displayTitle,
                      ),
                      const SizedBox(height: 20),
                      _DetailRow(
                        label: 'Rental Period',
                        value: item.displayRentalPeriod,
                      ),
                      const SizedBox(height: 20),
                      _DetailRow(
                        label: 'Payment Method',
                        value: item.displayPaymentMethod,
                      ),
                      const SizedBox(height: 20),
                      _DetailRow(
                        label: 'Reference No',
                        value: item.paymentNo.isEmpty ? '-' : item.paymentNo,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAF8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: _successGreen,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.payoutHeadline,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'HG',
                                  fontVariations: [FontVariation('wght', 400)],
                                  height: 1.4,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.isPayoutQueued) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'No money is moved in this demo. Admin or the future backend still transfers to the owner bank.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                      if (item.isHeldPayout) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () => context.push(
                              AppRoutes.ownerInvite,
                              extra: OwnerInviteArgs(
                                history: item,
                                ownerName: item.landlordName,
                              ),
                            ),
                            child: const Text('Invite owner'),
                          ),
                        ),
                      ],
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  static const _textStyle = TextStyle(
    fontSize: 15,
    fontFamily: 'HG',
    fontVariations: [FontVariation('wght', 400)],
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: _textStyle)),
        Expanded(
          child: Text(value, textAlign: TextAlign.right, style: _textStyle),
        ),
      ],
    );
  }
}
