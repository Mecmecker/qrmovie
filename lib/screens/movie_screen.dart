// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/movies_models.dart';

import 'package:qrmovie/widgets/bottom.dart';

class CartelMovie extends StatefulWidget {
  final String id;

  const CartelMovie({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CartelMovie> createState() => _CartelMovieState();
}

class _CartelMovieState extends State<CartelMovie> {
  final _auth = FirebaseAuth.instance;
  final fb = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Preventa(),
      ),
    );
  }

  // Column EntradasCogidas() {
  //   final TextStyle styleTile = TextStyle(
  //     fontSize: 20,
  //     fontWeight: FontWeight.bold,
  //   );
  //   return Column(
  //     children: [
  //       CartelPrincipal(
  //         asset: widget.pelicula.asset,
  //       ),
  //       Expanded(
  //         child: Container(
  //           child: ListView.separated(
  //               itemBuilder: (context, index) => Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: ListTile(
  //                       tileColor: Colors.red,
  //                       leading: Stack(children: [
  //                         Container(
  //                           height: 40,
  //                           child: Image(
  //                             image: AssetImage('assets/entrada-de-cine.png'),
  //                           ),
  //                         ),
  //                         Text(
  //                           '${misEntradas[index].num}',
  //                           style: styleTile,
  //                         ),
  //                       ]),
  //                       title: Text(widget.pelicula.titulo),
  //                       subtitle: Text(
  //                         'Hora de la sesion: $horaSesion',
  //                       ),
  //                     ),
  //                   ),
  //               separatorBuilder: (context, index) => Divider(
  //                     height: 1,
  //                     thickness: 1,
  //                   ),
  //               itemCount: misEntradas.length),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           Navigator.of(context).pop(misEntradas);
  //         },
  //         child: bottomRow(
  //           butaca: misEntradas,
  //         ),
  //       )
  //     ],
  //   );
  // }

  Preventa() {
    return FutureBuilder(
        future: loadFilms(
            'https://api.themoviedb.org/3/movie/${widget.id}?api_key=abc812104604d02963af68e823d82dee'),
        builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  CartelPrincipal(
                    asset: 'https://image.tmdb.org/t/p/w500' +
                        snapshot.data!.poster,
                  ),
                ]);
          }
          return Text('loading');
        });
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
