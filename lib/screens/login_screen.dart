import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:qrmovie/screens/cartelera_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _controllerEmail, _controllerPwd;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _controllerEmail = TextEditingController();
    _controllerPwd = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogIn Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  hintText: 'Password',
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
                              await _auth.signInWithEmailAndPassword(
                                  email: _controllerEmail.text,
                                  password: _controllerPwd.text);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CarteleraScreen()));
                            } on FirebaseAuthException catch (e) {
                              Fluttertoast.showToast(
                                  msg: 'Usuario o Contraseña incorrectos');
                            }
                        },
                        child: Text('Login')),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await _auth.createUserWithEmailAndPassword(
                                email: _controllerEmail.text,
                                password: _controllerPwd.text);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CarteleraScreen()));
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
    );
  }
}
