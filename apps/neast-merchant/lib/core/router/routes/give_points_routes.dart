import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/give_points/models/receipt_capture_result.dart';
import 'package:neast/features/give_points/models/receipt_confirm_payload.dart';
import 'package:neast/features/give_points/pages/confirm_points_screen.dart';
import 'package:neast/features/give_points/pages/receipt_details_screen.dart';

final List<GoRoute> givePointsRoutes = [
  GoRoute(
    path: AppRoutes.receiptDetails,
    name: 'receiptDetails',
    builder: (context, state) {
      final capture = state.extra;
      if (capture is! ReceiptCaptureResult || !capture.hasUploaded) {
        return const ReceiptDetailsMissingScreen();
      }
      return ReceiptDetailsScreen(capture: capture);
    },
  ),
  GoRoute(
    path: AppRoutes.confirmPoints,
    name: 'confirmPoints',
    builder: (context, state) {
      final payload = state.extra;
      if (payload is! ReceiptConfirmPayload) {
        return const ConfirmPointsMissingScreen();
      }
      return ConfirmPointsScreen(payload: payload);
    },
  ),
];

/// extra 缺失时的兜底页。
class ReceiptDetailsMissingScreen extends StatelessWidget {
  const ReceiptDetailsMissingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Details')),
      body: const Center(child: Text('Receipt image not found.')),
    );
  }
}
