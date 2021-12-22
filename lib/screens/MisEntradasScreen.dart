// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:qrmovie/models/tickets_model.dart';
import 'package:qrmovie/screens/MisEntradasScreen.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Welcome ${_auth.currentUser!.email}',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 20,
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
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: (opcion
                ? AvaiableEntradas(auth: _auth)
                : OutOfDateEntradas(auth: _auth)),
          ),
        ],
      ),
    );
  }
}

class OutOfDateEntradas extends StatelessWidget {
  const OutOfDateEntradas({
    Key? key,
    required FirebaseAuth auth,
  })  : _auth = auth,
        super(key: key);

  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Tickets')
          .where('user_id', isEqualTo: _auth.currentUser!.uid)
          .where('dia', isLessThan: DateTime.now())
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
                title: Text(
                  '${data[index].id_sesion}',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
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

class AvaiableEntradas extends StatelessWidget {
  const AvaiableEntradas({
    Key? key,
    required this.auth,
  }) : super(key: key);
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Tickets')
          .where('user_id', isEqualTo: auth.currentUser!.uid)
          .where('dia', isGreaterThanOrEqualTo: DateTime.now())
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
                "No tienes entradas para proximas sesiones",
                style: TextStyle(fontSize: 26),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data!.docs
              .map((e) => Tickets.fromJson(e.data()))
              .toList();
          return ListView.builder(
            itemBuilder: (context, index) => Card(
              child: SizedBox(
                height: 460,
                child: Column(
                  children: [
                    QrImage(data: data[index].toString()),
                    SizedBox(
                      height: 20,
                    ),
                    Text('${data[index].id_sesion}'),
                  ],
                ),
              ),
            ),
            itemCount: data.length,
          );
        }
        return Text('loading');
      },
    );
  }
}
