// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:qrmovie/models/butaca_model.dart';
import 'package:qrmovie/models/peli_model.dart';
import 'package:qrmovie/models/persona_model.dart';
import 'package:qrmovie/screens/sesion_screen.dart';
import 'package:qrmovie/widgets/bottom.dart';

class CartelPelicula extends StatefulWidget {
  final Peli pelicula;
  final Persona usuario;
  const CartelPelicula(
      {Key? key, required this.pelicula, required this.usuario})
      : super(key: key);

  @override
  State<CartelPelicula> createState() => _CartelPeliculaState();
}

class _CartelPeliculaState extends State<CartelPelicula> {
  List<Butaca> misEntradas = [];
  late TimeOfDay horaSesion;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: (misEntradas.isEmpty ? Preventa() : EntradasCogidas()),
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
        CartelPrincipal(),
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
                          'Hora de la sesion: ${horaSesion.hour}:${horaSesion.minute}',
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
        CartelPrincipal(),
        InfoPelicula(
          pelicula: widget.pelicula,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          width: 150,
          child: ListView.builder(
            physics: PageScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FloatingActionButton.extended(
                  heroTag: null,
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => SalaScreen(
                                sesion: widget.pelicula.sesiones[index],
                                titulo: widget.pelicula.titulo)))
                        .then((entradas) {
                      if (entradas != null)
                        setState(() {
                          horaSesion = entradas[0];
                          misEntradas = entradas[1];
                          misEntradas.sort((a, b) => a.num.compareTo(b.num));
                          for (var entrada in entradas[1]) {
                            widget
                                .pelicula
                                .sesiones[index]
                                .butaques[entrada.num]
                                .ocupada = widget.usuario.nom;
                          }
                        });
                    });
                  },
                  label: Text(
                    '${widget.pelicula.sesiones[index].hora.hour}:${widget.pelicula.sesiones[index].hora.minute}',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              );
            },
            itemCount: widget.pelicula.sesiones.length,
            scrollDirection: Axis.horizontal,
          ),
        ),
        SizedBox(height: 14),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            width: 300,
            height: 60,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              foregroundColor: Colors.white,
              onPressed: () {},
              label: Text(
                "Reservar",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CartelPrincipal extends StatelessWidget {
  const CartelPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset('assets/venom.png'),
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
  final Peli pelicula;
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
