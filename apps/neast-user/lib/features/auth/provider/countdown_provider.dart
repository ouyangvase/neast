import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 按手机号区分的独立倒计时
/// 使用 NotifierProvider.family，同一手机号共享同一实例
class CountdownNotifier extends Notifier<int> {
  CountdownNotifier(this.phone);
  final String phone;

  Timer? _timer;

  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  /// 启动倒计时（若已在计数中则不重启，保留现有进度）
  void start() {
    if (state > 0) return;
    _run();
  }

  /// 强制重新发送（重置并重启）
  void restart() {
    _timer?.cancel();
    _run();
  }

  void _run() {
    state = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state > 0) {
        state--;
      } else {
        t.cancel();
      }
    });
  }

  int getCountdown() {
    return state;
  }
}

final countdownProvider = NotifierProvider.family<CountdownNotifier, int, String>(
  // (String phone) => CountdownNotifier(phone),
  CountdownNotifier.new,
);
