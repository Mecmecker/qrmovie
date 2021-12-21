// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:qrmovie/models/tickets_model.dart';

class EntradasReservadas extends StatefulWidget {
  const EntradasReservadas({Key? key}) : super(key: key);

  @override
  _EntradasReservadasState createState() => _EntradasReservadasState();
}

class _EntradasReservadasState extends State<EntradasReservadas> {
  bool opcion = true;
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
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ))
        ],
        title: Text("Mis Entradas"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Welcome ${_auth.currentUser!.email}',
            style: TextStyle(fontSize: 24),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    if (!opcion) {
                      setState(() {
                        opcion = true;
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor:
                          opcion ? Colors.green[700] : Colors.green[100]),
                  child: Text(
                    'Current',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (opcion) {
                      setState(() {
                        opcion = false;
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor:
                          opcion ? Colors.red[100] : Colors.red[700]),
                  child: Text('Out of date', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
          opcionesEntradas(auth: _auth, opcion: opcion),
        ],
      ),
    );
  }
}

class opcionesEntradas extends StatelessWidget {
  const opcionesEntradas({
    Key? key,
    required FirebaseAuth auth,
    required this.opcion,
  })  : _auth = auth,
        super(key: key);
  final bool opcion;
  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Tickets')
          .where('user_id', isEqualTo: _auth.currentUser!.uid)
          .where('dia', isLessThan: Timestamp.now())
          .get(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData && !snapshot.data!.docs.isNotEmpty) {
          return Center(
            child: Container(
              child: Text(
                "No tienes entradas",
                style: TextStyle(fontSize: 26),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!.docs
              .map((e) => Tickets.fromJson(e.data()))
              .toList();
          return Container(
            height: 500,
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text('${data[index].butaca}'),
              ),
              itemCount: data.length,
            ),
          );
        }
        return Text('loading');
      },
    );
  }
}
