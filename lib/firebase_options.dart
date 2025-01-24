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
    apiKey: 'AIzaSyC-B_9JJz9s4KQKCny9Yp5t_Zu4wLxs518',
    appId: '1:89209270719:web:65e17810809d6ba839f10a',
    messagingSenderId: '89209270719',
    projectId: 'volonariat',
    authDomain: 'volonariat.firebaseapp.com',
    storageBucket: 'volonariat.appspot.com',
    measurementId: 'G-GPQMNJ9QKZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCZdP-EADUDcJ0FQACR0wWpLO8SFLwvDWI',
    appId: '1:89209270719:android:80cf6325e577d63039f10a',
    messagingSenderId: '89209270719',
    projectId: 'volonariat',
    storageBucket: 'volonariat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEB_am_zubfXRfkWQUcZkyuVA_Q21O5Co',
    appId: '1:89209270719:ios:d0dca988ab84cb8439f10a',
    messagingSenderId: '89209270719',
    projectId: 'volonariat',
    storageBucket: 'volonariat.appspot.com',
    iosBundleId: 'com.example.volontariat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEB_am_zubfXRfkWQUcZkyuVA_Q21O5Co',
    appId: '1:89209270719:ios:d0dca988ab84cb8439f10a',
    messagingSenderId: '89209270719',
    projectId: 'volonariat',
    storageBucket: 'volonariat.appspot.com',
    iosBundleId: 'com.example.volontariat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC-B_9JJz9s4KQKCny9Yp5t_Zu4wLxs518',
    appId: '1:89209270719:web:a33aaa392abfbe5239f10a',
    messagingSenderId: '89209270719',
    projectId: 'volonariat',
    authDomain: 'volonariat.firebaseapp.com',
    storageBucket: 'volonariat.appspot.com',
    measurementId: 'G-YELN5N7M60',
  );
}
