import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/features/tent_score/models/tent_score_model.dart';
import 'package:neast/features/tent_score/services/tent_score_service.dart';

final tentScoreProvider = FutureProvider<TentScoreModel>((ref) {
  ref.keepAlive();
  return ref.watch(tentScoreServiceProvider).fetchTentScore();
});
