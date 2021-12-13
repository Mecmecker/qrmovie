// ignore_for_file: prefer_const_constructors, duplicate_ignore, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/sesiones_model.dart';
import 'package:qrmovie/models/tickets_model.dart';
import 'package:qrmovie/widgets/bottom.dart';

class TheaterScreen extends StatefulWidget {
  final Sesiones sesion;
  final Query<Map<String, dynamic>> docRef;
  const TheaterScreen({Key? key, required this.sesion, required this.docRef})
      : super(key: key);

  @override
  State<TheaterScreen> createState() => _TheaterScreenState();
}

class _TheaterScreenState extends State<TheaterScreen> {
  @override
  Widget build(BuildContext context) {
    final fb = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Theater'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: widget.docRef.get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.docs.isNotEmpty) {
              return Text("Document does not exist");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data!.docs
                  .map((e) => Sesiones.fromJson(e.data()))
                  .toList();
              final ref = snapshot.data!.docs.map((e) => e.id).toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      height: 50,
                      child: Text(
                        'hola',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      child: Text(
                        '${widget.sesion.hora.hour}:${widget.sesion.hora.minute}',
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  Teatro(sesion: data[0], docRef: ref[0]),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Circulito(
                            color: Colors.grey,
                          ),
                          Text('Avaiable'),
                          Circulito(
                            color: Colors.blue,
                          ),
                          Text('Reserved'),
                          Circulito(
                            color: Colors.red,
                          ),
                          Text('Selected'),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Text('loading');
          },
        ),
      ),
    );
  }
}

class Teatro extends StatefulWidget {
  final Sesiones sesion;
  final String docRef;
  const Teatro({Key? key, required this.sesion, required this.docRef})
      : super(key: key);

  @override
  State<Teatro> createState() => _TeatroState();
}

class _TeatroState extends State<Teatro> {
  final _auth = FirebaseAuth.instance;
  List<int> seleccionadas = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Tickets')
              .where("sesion_id", isEqualTo: widget.docRef)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final docs = snapshot.data!.docs
                .map((e) => Tickets.fromJson(e.data()).butaca);
            return Container(
              height: 400,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  if (docs.contains(index)) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 6,
                        height: 6,
                        child: Image.asset('assets/asiento-de-cine-on.png'),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (seleccionadas.contains(index)) {
                          seleccionadas.remove(index);
                        } else {
                          seleccionadas.add(index);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 6,
                        height: 6,
                        child: (!seleccionadas.contains(index)
                            ? Image.asset('assets/asiento-de-cine.png')
                            : Image.asset('assets/cinema-seat.png')),
                      ),
                    ),
                  );
                },
                itemCount: widget.sesion.numeroButacas,
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            if (seleccionadas.isNotEmpty) {
              List<Tickets> tickets = [
                for (var n in seleccionadas)
                  Tickets(
                      butaca: n,
                      id_sesion: widget.docRef,
                      id_user: _auth.currentUser!.uid)
              ];
              Navigator.of(context).pop(tickets);
            }
          },
          child: bottomRow(
            butaca: seleccionadas,
          ),
        )
      ],
    );
  }
}

class Circulito extends StatelessWidget {
  final Color color;
  const Circulito({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
          // ignore: unnecessary_this
          color: this.color,
          borderRadius: BorderRadius.circular(6)),
    );
  }
}
