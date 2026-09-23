import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/pay_rent/models/rent_history_model.dart';
import 'package:neast/features/pay_rent/services/rent_service.dart';

/// 租金详情页：指定租约的全部还款历史（Property Journey）。
final rentDetailHistoryProvider =
    FutureProvider.autoDispose.family<List<RentHistoryModel>, int>(
  (ref, rentId) async {
    return ref.read(rentServiceProvider).fetchHistoryByRentId(rentId);
  },
);
