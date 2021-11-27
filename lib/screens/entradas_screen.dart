import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/persona_model.dart';
import 'package:qrmovie/screens/logIn.dart';

class MisEntradasScreen extends StatefulWidget {
  const MisEntradasScreen({Key? key}) : super(key: key);

  @override
  _MisEntradasScreenState createState() => _MisEntradasScreenState();
}

class _MisEntradasScreenState extends State<MisEntradasScreen> {
  final auth = FirebaseAuth.instance;
  final fb = FirebaseFirestore.instance;

  late List<String> data;
  @override
  _cargar() async {
    var data = await fb
        .collection('Personas')
        .doc(auth.currentUser!.uid)
        .collection('Entradas')
        .snapshots()
        .toList();
  }

  @override
  void initState() {
    _cargar();
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
          Text('${auth.currentUser!.email}   ${auth.currentUser!.displayName}'),
          TextButton(
              onPressed: () async {
                await auth.signOut();
                if (auth.currentUser == null) Navigator.of(context).pop();
              },
              child: Text('Logout')),
          Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Text(data[index]);
              },
              itemCount: data.length,
            ),
          )
        ],
      ),
    );
  }
}
