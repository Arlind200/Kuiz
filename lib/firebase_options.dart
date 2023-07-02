// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform,kIsWeb, TargetPlatform;

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
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    else if(kIsWeb){
      return web;
    }
  
     throw UnsupportedError(
          'Error 0000.',
        );
   
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBovhL8r_xVN8qanx8Ctznt_ZYCDcE8eo0',
    appId: '1:435846162970:android:a50353c2c4873936403fa3',
    messagingSenderId: '435846162970',
    projectId: 'kuiz-29083',
    storageBucket: 'kuiz-29083.appspot.com',
  );
  static const FirebaseOptions web= FirebaseOptions(
  apiKey: "AIzaSyD3HhAzHXLN84vFQbPoi_z4yxBk9ep212c",
  authDomain: "kuiz-29083.firebaseapp.com",
  databaseURL: "https://kuiz-29083-default-rtdb.firebaseio.com",
  projectId: "kuiz-29083",
  storageBucket: "kuiz-29083.appspot.com",
  messagingSenderId: "435846162970",
  appId: "1:435846162970:web:46f22b46e31b46f7403fa3"
  );

}
