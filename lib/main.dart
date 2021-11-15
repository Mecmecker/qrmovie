import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/screens/cartelera_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: CarteleraScreen(),
    );
  }
}

void main() {
  runApp(MyApp());
}
