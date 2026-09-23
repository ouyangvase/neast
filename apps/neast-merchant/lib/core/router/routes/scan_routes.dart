import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/scan/pages/qr_scanner_screen.dart';

final List<GoRoute> scanRoutes = [
  GoRoute(
    path: AppRoutes.scanner,
    name: 'scanner',
    builder: (context, state) => const QrScannerScreen(),
  ),
];
