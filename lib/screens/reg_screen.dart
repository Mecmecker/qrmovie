// ignore_for_file: unused_catch_clause, curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrmovie/screens/qr_scanner_screen.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  _RegScreenState createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  late TextEditingController _controllerEmail, _controllerPwd, _controllerNom;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _controllerNom = TextEditingController();
    _controllerEmail = TextEditingController();
    _controllerPwd = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/LOGO.png'),
                TextField(
                  controller: _controllerNom,
                  decoration: InputDecoration(
                    hintText: 'Put your name',
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.image),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                    hintText: 'Put your email',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _controllerPwd,
                  decoration: InputDecoration(
                    hintText: 'Write your password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (_controllerEmail.text.isNotEmpty &&
                                _controllerPwd.text.isNotEmpty)
                              try {
                                await _auth
                                    .createUserWithEmailAndPassword(
                                        email: _controllerEmail.text,
                                        password: _controllerPwd.text)
                                    .then((user) {
                                  user.user!
                                      .updateDisplayName(_controllerNom.text);
                                  FirebaseFirestore.instance
                                      .collection('Personas')
                                      .doc(user.user!.uid)
                                      .collection('Entradas')
                                      .doc();
                                });
                                await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QrScannerScreen()));
                              } on FirebaseAuthException catch (e) {
                                Fluttertoast.showToast(
                                    msg: 'Usuario o Contraseña ya existentes');
                              }
                          },
                          child: Text('Registrar')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
