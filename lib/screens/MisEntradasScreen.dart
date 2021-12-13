// ignore_for_file: file_names, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EntradasReservadas extends StatefulWidget {
  const EntradasReservadas({Key? key}) : super(key: key);

  @override
  _EntradasReservadasState createState() => _EntradasReservadasState();
}

class _EntradasReservadasState extends State<EntradasReservadas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ))
        ],
        title: Text("Mis Entradas"),
      ),
      //body: ListV,
    );
  }
}
