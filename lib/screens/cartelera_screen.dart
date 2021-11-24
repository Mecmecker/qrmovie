import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrmovie/models/modelo_pelijson.dart';
import 'package:qrmovie/models/peli_model.dart';
import 'package:qrmovie/models/persona_model.dart';
import 'package:qrmovie/models/sesion_model.dart';
import 'package:qrmovie/screens/cartel_peli_screen.dart';
import 'package:qrmovie/models/datosfalsos.dart';

class CarteleraScreen extends StatefulWidget {
  const CarteleraScreen({Key? key}) : super(key: key);

  @override
  _CarteleraScreenState createState() => _CarteleraScreenState();
}

class _CarteleraScreenState extends State<CarteleraScreen> {
  List data = [];
  List<Pelicula> peliss = [];
  final _auth = FirebaseAuth.instance;
  final fb = FirebaseFirestore.instance;

  void _crearNuevaCollection() async {
    for (var x in peliss)
      await fb.collection('Peliculas').doc('${x.id}').set(x.toJson());
  }

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/films.json');
    setState(() => data = json.decode(jsonText));
    for (var x in data) {
      peliss.add(Pelicula.fromJson(x));
    }
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
    _crearNuevaCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text(data == null ? 'Mis entradas' : '${peliss.length}'),
                  Image.asset('assets/entrada-de-cine.png')
                ],
              ))
        ],
        title: Text('Cartelera'),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => CartelPelicula(
                        pelicula: peliss[index], id: peliss[index].id)))
                .then((entradas) {
              setState(() async {
                for (var x in entradas)
                  await fb
                      .collection('Personas')
                      .doc(_auth.currentUser!.uid)
                      .collection('entradas')
                      .doc()
                      .set(x.toJson());
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Stack(
              children: [
                Container(
                  child: (peliss[index].asset != null
                      ? Image.network(peliss[index].asset)
                      : Image.asset('assets/venom.png')),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(peliss[index].titulo)),
              ],
            )),
          ),
        ),
        itemCount: peliss.length,
      ),
    );
  }
}
