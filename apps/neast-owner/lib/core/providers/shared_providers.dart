import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences的Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('需要先初始化SharedPreferences');
});

// Logger的Provider
final loggerProvider = Provider<Logger>((ref) {
  return Logger(printer: PrettyPrinter());
}); 