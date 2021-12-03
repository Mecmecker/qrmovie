import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:qrmovie/screens/logIn.dart';

class MisEntradasScreen extends StatefulWidget {
  const MisEntradasScreen({Key? key}) : super(key: key);

  @override
  _MisEntradasScreenState createState() => _MisEntradasScreenState();
}

class _MisEntradasScreenState extends State<MisEntradasScreen> {
  final auth = FirebaseAuth.instance;
  final fb = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Entradas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 20),
            child: Container(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Usuario:  ${auth.currentUser!.displayName}'),
                    SizedBox(
                      width: 30,
                    ),
                    Text('Email:    ${auth.currentUser!.email}'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Text(
            'Tus codigos de entradas',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: fb
                      .collection('Personas')
                      .doc(auth.currentUser!.uid)
                      .collection('entradas')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final docs = snapshot.data!.docs;
                    return ListView(
                      children: docs.map((document) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.red,
                            title: Text(
                              document.id,
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Image(
                              image: AssetImage('assets/miniqr.png'),
                              height: 40,
                              width: 40,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                await auth.signOut();
                if (auth.currentUser == null)
                  Navigator.of(context).popUntil((ruta) => ruta.isFirst);
              },
              child: Text('Logout')),
        ],
      ),
    );
  }
}
