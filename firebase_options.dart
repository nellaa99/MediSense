
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] 



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
    apiKey: 'AIzaSyAbAT-hMgv43KymYSoU2pLLhCJULAHl32Q',
    appId: '1:249784569944:web:f8c382daa525414b947a2d',
    messagingSenderId: '249784569944',
    projectId: 'medisense-16b22',
    authDomain: 'medisense-16b22.firebaseapp.com',
    storageBucket: 'medisense-16b22.firebasestorage.app',
    measurementId: 'G-RG0XWC9NP2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBk3h9ZEz47stxMKuA4C0WgXF5ybKIbQMA',
    appId: '1:249784569944:android:5852bf8dafb06843947a2d',
    messagingSenderId: '249784569944',
    projectId: 'medisense-16b22',
    storageBucket: 'medisense-16b22.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA130BV9rUH5b0flwoJuzu8Rv7CFFaROb4',
    appId: '1:249784569944:ios:f938adb25c93df34947a2d',
    messagingSenderId: '249784569944',
    projectId: 'medisense-16b22',
    storageBucket: 'medisense-16b22.firebasestorage.app',
    iosBundleId: 'com.example.medisense',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA130BV9rUH5b0flwoJuzu8Rv7CFFaROb4',
    appId: '1:249784569944:ios:f938adb25c93df34947a2d',
    messagingSenderId: '249784569944',
    projectId: 'medisense-16b22',
    storageBucket: 'medisense-16b22.firebasestorage.app',
    iosBundleId: 'com.example.medisense',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAbAT-hMgv43KymYSoU2pLLhCJULAHl32Q',
    appId: '1:249784569944:web:203f76b61ed52eef947a2d',
    messagingSenderId: '249784569944',
    projectId: 'medisense-16b22',
    authDomain: 'medisense-16b22.firebaseapp.com',
    storageBucket: 'medisense-16b22.firebasestorage.app',
    measurementId: 'G-6GVEB6ZCFV',
  );

}