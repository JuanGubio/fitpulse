import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAJBOZxPEwozVms5jqTPDoiwUPjpF4Bi0k',
    appId: '1:66599664409:web:example-app-id',
    messagingSenderId: '66599664409',
    projectId: 'fitpulse-9002e',
    authDomain: 'fitpulse-9002e.firebaseapp.com',
    storageBucket: 'fitpulse-9002e.appspot.com',
    measurementId: 'G-XXXXXXXXXX',
    databaseURL: 'https://fitpulse-9002e-default-rtdb.firebaseio.com/',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-example-api-key',
    appId: '1:499076441306:android:example-app-id',
    messagingSenderId: '499076441306',
    projectId: 'fitpulse-9002e',
    storageBucket: 'fitpulse-9002e.appspot.com',
    databaseURL: 'https://fitpulse-9002e-default-rtdb.firebaseio.com/',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-example-api-key',
    appId: '1:499076441306:ios:example-app-id',
    messagingSenderId: '499076441306',
    projectId: 'fitpulse-9002e',
    storageBucket: 'fitpulse-9002e.appspot.com',
    databaseURL: 'https://fitpulse-9002e-default-rtdb.firebaseio.com/',
  );
}