// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:qrmovie/screens/qr_scanner_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error.toString());
          }
          final user = snapshot.data;
          if (user == null) {
            const providers = [EmailProviderConfiguration()];
            return SignInScreen(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  // Navigator.pushReplacementNamed(context, '/qr-scann');
                }),
              ],
              providerConfigs: providers,
            );
          } else {
            return QrScannerScreen();
          }
        },
      ),
    );
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
