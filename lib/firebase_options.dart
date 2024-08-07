// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDjuvZE31_GYXiyGuH6cMkCd0TNeT40Cts',
    appId: '1:996492140717:web:157ff62661266a3a7f6624',
    messagingSenderId: '996492140717',
    projectId: 'chat-flutter-189da',
    databaseURL: 'https://chat-flutter-189da-default-rtdb.firebaseio.com/',
    authDomain: 'chat-flutter-189da.firebaseapp.com',
    storageBucket: 'chat-flutter-189da.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrJgBlmnvA4N90td2kDq2CirzzE5Grmqw',
    appId: '1:996492140717:android:cabc5ca222d934ae7f6624',
    messagingSenderId: '996492140717',
    projectId: 'chat-flutter-189da',
    databaseURL: 'https://chat-flutter-189da-default-rtdb.firebaseio.com/',
    storageBucket: 'chat-flutter-189da.appspot.com',
  );
}
