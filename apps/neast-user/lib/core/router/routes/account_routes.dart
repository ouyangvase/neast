import 'package:go_router/go_router.dart';
import 'package:neast/core/router/routes.dart';
import 'package:neast/features/account/models/personal_data_field.dart';
import 'package:neast/features/account/pages/my_qr_screen.dart';
import 'package:neast/features/account/pages/personal_data_edit_screen.dart';
import 'package:neast/features/account/pages/personal_data_screen.dart';
import 'package:neast/features/tent_score/pages/tent_score_screen.dart';

final List<GoRoute> accountRoutes = [
  GoRoute(
    path: AppRoutes.personalData,
    name: 'personalData',
    builder: (context, state) => const PersonalDataScreen(),
  ),
  GoRoute(
    path: AppRoutes.personalDataEdit,
    name: 'personalDataEdit',
    builder: (context, state) {
      final field = state.extra as PersonalDataField;
      return PersonalDataEditScreen(field: field);
    },
  ),
  GoRoute(
    path: AppRoutes.myQr,
    name: 'myQr',
    builder: (context, state) => const MyQrScreen(),
  ),
  GoRoute(
    path: AppRoutes.tentScore,
    name: 'tentScore',
    builder: (context, state) => const TentScoreScreen(),
  ),
];
