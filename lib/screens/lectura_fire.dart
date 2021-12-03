import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/movies_models.dart';
import 'package:qrmovie/models/sesiones_model.dart';
import 'package:qrmovie/screens/movie_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Primera extends StatefulWidget {
  const Primera({Key? key}) : super(key: key);

  @override
  _PrimeraState createState() => _PrimeraState();
}

class _PrimeraState extends State<Primera> {
  final fb = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Map<String, List<Sesiones>> lista = {};

    return Scaffold(
        appBar: AppBar(
          title: Text('Pruebas'),
        ),
        body: FutureBuilder(
          future: fb
              .collection('Sessions')
              .where('Cine', isEqualTo: 'La Maquinista')
              .get(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.docs.isNotEmpty) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data!.docs;
              var result = data.map((e) {
                return Sesiones.fromJson(e.data());
              }).toList();
              for (var ses in result) {
                if (lista[ses.movieId] != null)
                  lista[ses.movieId]!.add(ses);
                else
                  lista[ses.movieId] = [ses];
              }

              return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: [
                    for (var x in lista.keys)
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CartelMovie(id: lista[x]![0].movieId),
                              ),
                            );
                          },
                          child: cartel(
                            id: int.parse(lista[x]![0].movieId),
                          ))
                  ].toList());
            }
            return Text('loading');
          },
        ));
  }
}

class cartel extends StatefulWidget {
  const cartel({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<cartel> createState() => _cartelState();
}

class _cartelState extends State<cartel> {
  Movie? pel;

  @override
  void initState() {
    final apiKey = dotenv.env['API_KEY'];
    loadFilms('https://api.themoviedb.org/3/movie/${widget.id}?api_key=$apiKey')
        .then((film) {
      setState(() {
        pel = film;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = 'https://image.tmdb.org/t/p/w500';
    if (pel == null) return CircularProgressIndicator();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 0),
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Image.network(
              imagePath + pel!.poster,
              fit: BoxFit.cover,
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: Text(pel!.nom)),
        ]),
      ),
    );
  }
}
