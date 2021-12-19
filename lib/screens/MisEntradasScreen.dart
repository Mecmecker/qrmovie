// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/tickets_model.dart';

class EntradasReservadas extends StatefulWidget {
  const EntradasReservadas({Key? key}) : super(key: key);

  @override
  _EntradasReservadasState createState() => _EntradasReservadasState();
}

class _EntradasReservadasState extends State<EntradasReservadas> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Tickets')
            .where('id_user', isEqualTo: _auth.currentUser!.uid)
            .get(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && !snapshot.data!.docs.isNotEmpty) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data!.docs
                .map((e) => Tickets.fromJson(e.data()))
                .toList();
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(),
              itemCount: data.length,
            );
          }
        },
      ),
    );
  }
}
