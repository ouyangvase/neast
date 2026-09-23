import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzDEz6bg3Albdy3PLGLNyUquvIKKcjXDE',
    appId: '1:233970307760:android:9c741c09abe93f8270a175',
    messagingSenderId: '233970307760',
    projectId: 'neast-73f05',
    storageBucket: 'neast-73f05.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCITZ49BuFRA9O0AD8HD8ZcpK-UPKg7FdU',
    appId: '1:233970307760:ios:29434263b763efc670a175',
    messagingSenderId: '233970307760',
    projectId: 'neast-73f05',
    storageBucket: 'neast-73f05.firebasestorage.app',
    iosBundleId: 'com.neastLandlords.flutter',
  );
}
