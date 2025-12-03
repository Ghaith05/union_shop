// Generated Firebase options placeholder file.
//
// This file provides a `DefaultFirebaseOptions` holder with `FirebaseOptions`
// structs for each supported platform. Replace the placeholder values below
// with your real Firebase project configuration, or run the FlutterFire CLI
// to generate this file automatically:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// IMPORTANT: Do NOT commit actual secrets here if you do not want them in
// your repository history. If you prefer, keep real values out-of-repo and
// inject them via CI secrets or environment variables.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return desktop;
      default:
        throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  // Web configuration

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCza0AxQDMU1Pcagl1ky8Oy6i2miShuTJY',
    appId: '1:148947852488:web:f22aa92589f97e259a19fd',
    messagingSenderId: '148947852488',
    projectId: 'union-shop-a986b',
    authDomain: 'union-shop-a986b.firebaseapp.com',
    storageBucket: 'union-shop-a986b.firebasestorage.app',
    measurementId: 'G-YMJF4ZHBDB',
  );

  // For Firebase JS SDK v7.20.0 and later, measurementId is optional

  // Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: '1:XXXXXXXXXXXX:android:xxxxxxxxxxxxxxxx',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'your-project.appspot.com',
  );

  // iOS / macOS configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:XXXXXXXXXXXX:ios:xxxxxxxxxxxxxxxx',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    iosBundleId: 'com.example.app',
    storageBucket: 'your-project.appspot.com',
  );

  // Desktop (Windows / Linux) placeholder: use the same as web or configure
  // a dedicated project if needed.
  static const FirebaseOptions desktop = FirebaseOptions(
    apiKey: 'YOUR_DESKTOP_API_KEY',
    appId: 'YOUR_DESKTOP_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'your-project.appspot.com',
  );
}