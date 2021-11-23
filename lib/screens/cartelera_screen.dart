import 'dart:convert';
import 'dart:io';

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
  Persona usuario = Persona(nom: 'Dani', correo: 'dani@gmail.com');

  List data = [];
  List<Pelicula> peliss = [];

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
                          pelicula: pelis[index],
                          usuario: usuario,
                        )))
                .then((entradas) {
              setState(() {
                usuario.entradas.addAll(entradas);
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Stack(
              children: [
                Container(
                  child: (pelis[index].asset != null
                      ? Image.asset(
                          pelis[index].asset!,
                        )
                      : Image.asset('assets/venom.png')),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(pelis[index].titulo)),
              ],
            )),
          ),
        ),
        itemCount: pelis.length,
      ),
    );
  }
}
