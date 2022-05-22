// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
///
///

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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
    apiKey: 'AIzaSyCKFwHREyzr_AfylA6mmsUvwxqMBcMvxJw',
    appId: '1:445024813251:web:5964a8c0b8c31c14b3e276',
    messagingSenderId: '445024813251',
    projectId: 'kelebikeapp-d4165',
    authDomain: 'kelebikeapp-d4165.firebaseapp.com',
    storageBucket: 'kelebikeapp-d4165.appspot.com',
    measurementId: 'G-FCLHCEDPQR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxJGnj1FIiTB8taSmsRzftZdsbxA9CiIk',
    appId: '1:445024813251:android:098630080f06dc9ab3e276',
    messagingSenderId: '445024813251',
    projectId: 'kelebikeapp-d4165',
    storageBucket: 'kelebikeapp-d4165.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDdEuVxE5w0xGAuCCeNUGCwMhhlVApNKU',
    appId: '1:445024813251:ios:25b677d9b601bca0b3e276',
    messagingSenderId: '445024813251',
    projectId: 'kelebikeapp-d4165',
    storageBucket: 'kelebikeapp-d4165.appspot.com',
    androidClientId:
        '445024813251-j7rrmhhqjafgmtbk0er3f1ukah5rb9dl.apps.googleusercontent.com',
    iosClientId:
        '445024813251-cjm1urn6rces0iv7sn8l15t437kavsd8.apps.googleusercontent.com',
    iosBundleId: 'com.bisquit.kelebike',
  );
}