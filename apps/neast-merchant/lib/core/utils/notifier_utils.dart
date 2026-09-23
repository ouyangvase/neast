import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neast/core/utils/toast_util.dart';
import 'package:neast/main.dart';

// 1. 针对 Provider 内部的 Ref
extension NotifierUtils on Ref {
  Future<T?> runGuarded<T>(
    Future<T> Function() action, {
    void Function(Object error, StackTrace stack)? onError,
  }) => _runGuarded(action, onError);
}

// 2. 针对 Widget 内部的 WidgetRef
extension WidgetRefUtils on WidgetRef {
  Future<T?> runGuarded<T>(
    Future<T> Function() action, {
    void Function(Object error, StackTrace stack)? onError,
  }) => _runGuarded(action, onError);
}

// 3. 抽离出的公共私有逻辑，避免重复代码
Future<T?> _runGuarded<T>(
  Future<T> Function() action,
  void Function(Object error, StackTrace stack)? onError,
) async {
  try {
    return await action();
  } on DioException catch (e) {
    final message = e.error?.toString().trim() ?? '';
    if (message.isNotEmpty) {
      ToastUtil.show(message);
      logger.d('error: $message');
    }
    return null;
  } catch (e, stack) {
    logger.e("Caught error: $e");
    onError?.call(e, stack);
    return null;
  }
}
