import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast_landlords/features/auth/services/auth_service.dart';
import 'package:neast_landlords/features/home/models/landlord_rent_detail_model.dart';
import 'package:neast_landlords/features/home/services/landlord_rent_service.dart';

final landlordRentDetailProvider =
    FutureProvider.family<LandlordRentDetailModel?, int>((ref, rentId) async {
  if (!ref.watch(authProvider) || rentId <= 0) {
    return null;
  }

  return ref.read(landlordRentServiceProvider).fetchDetail(rentId);
});
