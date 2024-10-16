import 'package:asau_chat/auth/auth_gate.dart';
//import 'package:asau_chat/auth/login_or_register.dart';
import 'package:asau_chat/firebase_options.dart';
import 'package:asau_chat/themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(), //const LoginOrRegister(),
      theme: lightMode,
    );
  }
}
