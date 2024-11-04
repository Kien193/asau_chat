import 'package:asau_chat/services/auth/auth_gate.dart';
import 'package:asau_chat/firebase_options.dart';
import 'package:asau_chat/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const ASauChat(),
    ),
  );
}

class ASauChat extends StatelessWidget {
  const ASauChat({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: themeProvider.themeData,
    );
  }
}