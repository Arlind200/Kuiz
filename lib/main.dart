import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Kuiz/auth/login.dart';
import 'package:Kuiz/pages/verify_email.dart';
import 'firebase_options.dart';
import './models/db_connect.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      
      key: UniqueKey(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const VerifyEmail();
            } else {
              return const LoginForm();
            }
          }),
    );
  }
}

void main() async {
  var db = DBconnect();

  db.fetchQuestions();

  WidgetsFlutterBinding.ensureInitialized();

  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      name: 'kuizi',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Orientimi i app-it
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}
