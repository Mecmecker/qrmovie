// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/butaca_model.dart';
import 'package:qrmovie/models/modelo_pelijson.dart';
import 'package:qrmovie/models/peli_model.dart';
import 'package:qrmovie/models/persona_model.dart';
import 'package:qrmovie/models/sesion_model.dart';
import 'package:qrmovie/screens/sala_con_butacas.dart';
import 'package:qrmovie/screens/sesion_screen.dart';
import 'package:qrmovie/widgets/bottom.dart';

class CartelPelicula extends StatefulWidget {
  final Pelicula pelicula;
  final String id;

  const CartelPelicula({Key? key, required this.pelicula, required this.id})
      : super(key: key);

  @override
  State<CartelPelicula> createState() => _CartelPeliculaState();
}

class _CartelPeliculaState extends State<CartelPelicula> {
  List<Butaca> misEntradas = [];
  late String horaSesion;
  final _auth = FirebaseAuth.instance;
  final fb = FirebaseFirestore.instance;

  List<String> _paths = [];

  Future<bool?> _encontrar() async {
    var encontrado = await fb
        .collection('Peliculas')
        .doc('gdsgsd')
        .get()
        .then((value) => value.exists);
  }

  /**void _crearNuevaCollection() async {
    for (var x in widget.pelicula.sesiones)
      for (var i in x.butaques)
        await fb
            .collection('Peliculas')
            .doc('${widget.pelicula.titulo}')
            .collection('Sesiones')
            .doc('${x.hora}')
            .collection('Butacas')
            .doc()
            .set(i.toJson());
  }
**/

  void _crearNuevaCollection() async {
    for (var x in widget.pelicula.sesiones) {
      final sesionRef =
          await fb.collection('/Peliculas/${widget.id}/Sesiones').doc(x).path;
      fb
          .collection('/Peliculas/${widget.id}/Sesiones')
          .doc(x)
          .set({'numButaques': 56, 'hora': x}, SetOptions(merge: true));
      _paths.add(sesionRef);
    }
  }

  @override
  void initState() {
    _crearNuevaCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
            child: (misEntradas.isEmpty ? Preventa() : EntradasCogidas())),
      ),
    );
  }

  Column EntradasCogidas() {
    final TextStyle styleTile = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        CartelPrincipal(
          asset: widget.pelicula.asset,
        ),
        Expanded(
          child: Container(
            child: ListView.separated(
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.red,
                        leading: Stack(children: [
                          Container(
                            height: 40,
                            child: Image(
                              image: AssetImage('assets/entrada-de-cine.png'),
                            ),
                          ),
                          Text(
                            '${misEntradas[index].num}',
                            style: styleTile,
                          ),
                        ]),
                        title: Text(widget.pelicula.titulo),
                        subtitle: Text(
                          'Hora de la sesion: $horaSesion',
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                    ),
                itemCount: misEntradas.length),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop(misEntradas);
          },
          child: bottomRow(
            butaca: misEntradas,
          ),
        )
      ],
    );
  }

  Column Preventa() {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        CartelPrincipal(
          asset: widget.pelicula.asset,
        ),
        InfoPelicula(
          pelicula: widget.pelicula,
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 80,
          width: 170,
          child: FutureBuilder(
            future: fb.collection('Peliculas').doc('${widget.id}').get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else
                return ListView.builder(
                  physics: PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 25),
                      child: FloatingActionButton.extended(
                        heroTag: null,
                        backgroundColor: Colors.red,
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => SalaButaca(
                                sesion: Sesion(
                                  hora: TimeOfDay(
                                      hour: int.parse(widget
                                          .pelicula.sesiones[index]
                                          .split(':')[0]),
                                      minute: int.parse(widget
                                          .pelicula.sesiones[index]
                                          .split(':')[1])),
                                ),
                                path: _paths[index],
                                titulo: widget.pelicula.titulo,
                                id: widget.pelicula.id,
                              ),
                            ),
                          )
                              .then((entradas) async {
                            if (entradas != null) {
                              setState(() {
                                horaSesion = entradas[0].toString();
                                misEntradas = entradas[1];
                                misEntradas
                                    .sort((a, b) => a.num.compareTo(b.num));
                              });
                            }
                          });
                        },
                        label: Text(
                          '${widget.pelicula.sesiones[index]}',
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.pelicula.sesiones.length,
                  scrollDirection: Axis.horizontal,
                );
            },
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }
}

class CartelPrincipal extends StatelessWidget {
  final String asset;
  const CartelPrincipal({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.network(asset),
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            )
          ],
        ),
      ],
    );
  }
}

class InfoPelicula extends StatelessWidget {
  final Pelicula pelicula;
  const InfoPelicula({Key? key, required this.pelicula}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              pelicula.titulo,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 5),
                  child: Icon(Icons.star, color: Colors.yellow),
                ),
              ),
            ),
            Text(
              '4.1',
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 14),
            Container(
              height: 25,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  'IMDB 6.3',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Text(
              'Director: Andy Serkis',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 6),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Text(
              'Writters: Kelly Marcel, Tom Hardy, Todd McFarlane',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Después de encontrar un cuerpo anfitrión en el periodista de investigación Eddie Brock, el simbionte alienígena debe enfrentarse a un nuevo enemigo, Carnage, el alter ego del asesino en serie Cletus Kasady.',
              style: TextStyle(
                height: 1.4,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
