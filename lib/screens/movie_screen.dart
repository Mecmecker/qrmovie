// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_string_interpolations, unused_field, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qrmovie/screens/theater_screen.dart';
import 'package:qrmovie/models/movies_models.dart';
import 'package:qrmovie/models/sesiones_model.dart';
import 'package:qrmovie/models/tickets_model.dart';
import 'package:qrmovie/widgets/bottom.dart';

class CartelMovieScreen extends StatefulWidget {
  final List<Sesiones> sesiones;

  const CartelMovieScreen({
    Key? key,
    required this.sesiones,
  }) : super(key: key);

  @override
  State<CartelMovieScreen> createState() => _CartelMovieScreenState();
}

class _CartelMovieScreenState extends State<CartelMovieScreen> {
  final _auth = FirebaseAuth.instance;
  final fb = FirebaseFirestore.instance;
  final apiKey = dotenv.env['API_KEY'];
  final Map<String, Tickets> tickets = {};
  String? cartelPeli;
  DateTime? horaPeli;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: (tickets.isEmpty ? Preventa() : EntradasCogidas()),
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
          asset: cartelPeli!,
          tickets: tickets.values.toList(),
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
                            '${tickets.values.toList()[index].butaca}',
                            style: styleTile,
                          ),
                        ]),
                        title: Text(widget.sesiones[0].cine),
                        subtitle: Text(
                          'Hora de la sesion: ${horaPeli!.hour}:${horaPeli!.minute} ',
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                    ),
                itemCount: tickets.length),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: bottomRow(
            butaca: tickets.values.toSet(),
          ),
        )
      ],
    );
  }

  Preventa() {
    return FutureBuilder(
        future: loadFilms(
            'https://api.themoviedb.org/3/movie/${widget.sesiones[0].movieId}?api_key=$apiKey'),
        builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            cartelPeli =
                'https://image.tmdb.org/t/p/w500' + snapshot.data!.poster;
            return SingleChildScrollView(
              child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CartelPrincipal(
                      asset: 'https://image.tmdb.org/t/p/w500' +
                          snapshot.data!.poster,
                      tickets: tickets.values.toList(),
                    ),
                    InfoPelicula(pelicula: snapshot.data!),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 80,
                      width: 170,
                      child: Expanded(
                        child: Container(
                          child: ListView.builder(
                            physics: PageScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 25),
                                child: FloatingActionButton.extended(
                                  heroTag: null,
                                  backgroundColor: Colors.red,
                                  onPressed: () {
                                    final docRef = FirebaseFirestore.instance
                                        .collection('Sessions')
                                        .where("Cine",
                                            isEqualTo:
                                                widget.sesiones[index].cine)
                                        .where("MovieId",
                                            isEqualTo:
                                                widget.sesiones[index].movieId)
                                        .where("Hora",
                                            isEqualTo:
                                                widget.sesiones[index].hora);
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => TheaterScreen(
                                          sesion: widget.sesiones[index],
                                          docRef: docRef,
                                        ),
                                      ),
                                    )
                                        .then((value) {
                                      if (value != null) {
                                        setState(() {
                                          horaPeli =
                                              widget.sesiones[index].hora;
                                          var fb = FirebaseFirestore.instance;
                                          for (Tickets ticket in value)
                                            fb
                                                .collection('Tickets')
                                                .add(ticket.toJson())
                                                .then((docref) =>
                                                    tickets[docref.id] =
                                                        ticket as Tickets);
                                        });
                                      }
                                    });
                                  },
                                  label: Text(
                                    '${widget.sesiones[index].hora.hour}:${widget.sesiones[index].hora.minute}',
                                    style: TextStyle(
                                        fontSize: 35, color: Colors.white),
                                  ),
                                ),
                              );
                            },
                            itemCount: widget.sesiones.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    )
                  ]),
            );
          }
          return Text('loading');
        });
  }
}

class CartelPrincipal extends StatelessWidget {
  final String asset;
  final List<Tickets> tickets;
  const CartelPrincipal({Key? key, required this.asset, required this.tickets})
      : super(key: key);

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
  final Movie pelicula;
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
              pelicula.nom,
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
              '${pelicula.rate / 2}',
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
                  'IMDB ${pelicula.rate}',
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
        Container(
          height: 50,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: pelicula.generos.map((genero) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        genero["name"],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
        Container(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              pelicula.info,
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
