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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA8TBi3DgbdUXz6eqshsN0dDXXhjVnEmBA',
    appId: '1:362037586492:web:6ff8851eb555e05409f139',
    messagingSenderId: '362037586492',
    projectId: 'asau-chat-kien',
    authDomain: 'asau-chat-kien.firebaseapp.com',
    storageBucket: 'asau-chat-kien.appspot.com',
    measurementId: 'G-BXNXXVVSRE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBci-0XfiHUkQDQLDu57-CMKTKZ5cjXzSw',
    appId: '1:362037586492:android:51788faf7c4bb37409f139',
    messagingSenderId: '362037586492',
    projectId: 'asau-chat-kien',
    storageBucket: 'asau-chat-kien.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1biBxDXvUqZFLJBqQQmDAGGZYJOpt_14',
    appId: '1:362037586492:ios:8a8794fe1031afd209f139',
    messagingSenderId: '362037586492',
    projectId: 'asau-chat-kien',
    storageBucket: 'asau-chat-kien.appspot.com',
    iosBundleId: 'com.example.asauChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC1biBxDXvUqZFLJBqQQmDAGGZYJOpt_14',
    appId: '1:362037586492:ios:8a8794fe1031afd209f139',
    messagingSenderId: '362037586492',
    projectId: 'asau-chat-kien',
    storageBucket: 'asau-chat-kien.appspot.com',
    iosBundleId: 'com.example.asauChat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA8TBi3DgbdUXz6eqshsN0dDXXhjVnEmBA',
    appId: '1:362037586492:web:b25b521adc237a3309f139',
    messagingSenderId: '362037586492',
    projectId: 'asau-chat-kien',
    authDomain: 'asau-chat-kien.firebaseapp.com',
    storageBucket: 'asau-chat-kien.appspot.com',
    measurementId: 'G-0K8KPVH9RV',
  );
}
