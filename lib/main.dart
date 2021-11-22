import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/services/usuario_modelo.dart';
import 'package:qrmovie/screens/cartelera_screen.dart';
import 'package:qrmovie/screens/logIn.dart';
import 'package:qrmovie/screens/login_screen.dart';
import 'package:qrmovie/screens/qr_scanner_screen.dart';
import 'package:provider/provider.dart';
import 'package:qrmovie/services/wrapper.dart';
import 'package:qrmovie/services/auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Usuario?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
