import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/pay_rent/models/rent_model.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';

final payRentListProvider = FutureProvider<RentListResponse>((ref) {
  return ref.read(rentServiceProvider).fetchList();
});
