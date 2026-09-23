import 'package:go_router/go_router.dart';
import 'package:neast_landlords/core/router/routes.dart';
import 'package:neast_landlords/features/properties/pages/add_property_screen.dart';

final List<GoRoute> propertiesRoutes = [
  GoRoute(
    path: AppRoutes.addProperty,
    name: 'addProperty',
    builder: (context, state) => const AddPropertyScreen(),
  ),
];
