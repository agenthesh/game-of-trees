// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-oWfrRmRrjAI_DHhdtdq3GjB7LYi_lgY',
    appId: '1:474044368123:android:e871be63ce9f6168bc9c5e',
    messagingSenderId: '474044368123',
    projectId: 'game-of-trees-df000',
    databaseURL: 'https://game-of-trees-df000-default-rtdb.firebaseio.com',
    storageBucket: 'game-of-trees-df000.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRRALGvUksP9K9bb7l0j72UpPn3vS0vl4',
    appId: '1:474044368123:ios:60d3d81aece47287bc9c5e',
    messagingSenderId: '474044368123',
    projectId: 'game-of-trees-df000',
    databaseURL: 'https://game-of-trees-df000-default-rtdb.firebaseio.com',
    storageBucket: 'game-of-trees-df000.appspot.com',
    iosClientId: '474044368123-o4oed37692jksk7194cpb8aldpmg4gkk.apps.googleusercontent.com',
    iosBundleId: 'com.pdlotko.gameoftrees',
  );
}
