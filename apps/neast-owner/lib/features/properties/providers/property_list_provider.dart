import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:neast_landlords/core/constants/app_constants.dart';
import 'package:neast_landlords/core/pagination/paginated_list_notifier.dart';
import 'package:neast_landlords/core/pagination/paginated_list_state.dart';
import 'package:neast_landlords/features/properties/models/property_model.dart';
import 'package:neast_landlords/features/properties/services/property_service.dart';

class PropertyListNotifier extends PaginatedListNotifier<PropertyModel> {
  @override
  int get initialPageSize => AppConstants.defaultPageSize;

  @override
  Future<List<PropertyModel>> fetchPage(int page, int pageSize) async {
    final response = await ref.read(propertyServiceProvider).fetchList(
          page: page,
          limit: pageSize,
        );
    ref.read(propertyListTotalProvider.notifier).state = response.total;
    return response.items;
  }
}

final propertyListProvider =
    NotifierProvider<PropertyListNotifier, PaginatedListState<PropertyModel>>(
  PropertyListNotifier.new,
);

final propertyListTotalProvider = StateProvider<int>((ref) => 0);
