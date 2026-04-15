// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS: return ios;
      default: throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: "virtualhospital-59bed",
    messagingSenderId: "571383792129",
    projectId: 'virtualhospital-xxxxx',
    storageBucket: "virtualhospital-59bed.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey:"Your_Api_key",
    appId:  "virtualhospital-59bed",
    messagingSenderId:  "571383792129",
    projectId:"virtualhospital-59bed",
    storageBucket:  "virtualhospital-59bed.firebasestorage.app",
    iosBundleId: 'com.example.virtual_hospital',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey:"your_api_key",
    appId:"1:571383792129:web:3213078300fa5bd8027600",
    messagingSenderId: '571383792129',
    projectId:"virtualhospital-59bed",
    authDomain: 'virtualhospital-59bed.firebaseapp.com',
    storageBucket: "virtualhospital-59bed.firebasestorage.app"
  );
}
