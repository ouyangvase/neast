import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/network/dio_client.dart';
import 'package:neast/features/tent_score/models/tent_score_model.dart';

class TentScoreService {
  TentScoreService(this._dioClient);

  final DioClient _dioClient;

  Future<TentScoreModel> fetchTentScore() async {
    final response = await _dioClient.get('/app/user/tent-score');
    return TentScoreModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}

final tentScoreServiceProvider = Provider<TentScoreService>((ref) {
  return TentScoreService(ref.watch(dioClientProvider));
});
