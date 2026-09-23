import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:neast/main.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.d('收到后台消息: ${message.messageId}');
  logger.d('消息标题: ${message.notification?.title}');
  logger.d('消息内容: ${message.notification?.body}');
  logger.d('消息数据: ${message.data}');
}
