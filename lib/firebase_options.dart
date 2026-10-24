// Firebase app values retrieved from askdocai-b699d using Firebase MCP.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.macOS => macos,
      TargetPlatform.windows => windows,
      TargetPlatform.iOS => throw UnsupportedError(
        'iOS support has been removed.',
      ),
      _ => throw UnsupportedError(
        'Firebase is not configured for this platform.',
      ),
    };
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDdZud2xmkI-fS4a9iFNsGV1P-Ej1GEr6I',
    appId: '1:5628303335:android:e1339ba542a2c2eb048f42',
    messagingSenderId: '5628303335',
    projectId: 'askdocai-b699d',
    storageBucket: 'askdocai-b699d.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCH4wWzc6F-WwTJ635Z6Z7yi0v_B-Z81sI',
    appId: '1:5628303335:web:e6d343f1c56d3ffd048f42',
    messagingSenderId: '5628303335',
    projectId: 'askdocai-b699d',
    storageBucket: 'askdocai-b699d.firebasestorage.app',
    authDomain: 'askdocai-b699d.firebaseapp.com',
    measurementId: 'G-NBD8VP0XDT',
  );

  // Windows uses the same registered web app, as supported by FlutterFire.
  static const FirebaseOptions windows = web;

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwqTDjqUzUoew46czYZZLxQ0pRldKEiw4',
    appId: '1:5628303335:ios:f38f4bd787d65fa9048f42',
    messagingSenderId: '5628303335',
    projectId: 'askdocai-b699d',
    storageBucket: 'askdocai-b699d.firebasestorage.app',
    iosBundleId: 'com.example.askdocai',
    iosClientId:
        '5628303335-kdbfh9darvg4s51frdqna80l45tmlept.apps.googleusercontent.com',
  );
}
