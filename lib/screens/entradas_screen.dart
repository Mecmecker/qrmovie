import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/screens/logIn.dart';
import 'package:qrmovie/services/wrapper.dart';

class MisEntradasScreen extends StatefulWidget {
  const MisEntradasScreen({Key? key}) : super(key: key);

  @override
  _MisEntradasScreenState createState() => _MisEntradasScreenState();
}

class _MisEntradasScreenState extends State<MisEntradasScreen> {
  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
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
              child: Text('Logout'))
        ],
      ),
    );
  }
}
