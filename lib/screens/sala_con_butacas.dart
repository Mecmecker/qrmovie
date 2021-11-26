import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/butaca_model.dart';
import 'package:qrmovie/models/sesion_model.dart';
import 'package:qrmovie/widgets/bottom.dart';

class SalaButaca extends StatefulWidget {
  final String id;
  final String titulo;
  final Sesion sesion;
  final String path;
  const SalaButaca(
      {Key? key,
      required this.sesion,
      required this.titulo,
      required this.path,
      required this.id})
      : super(key: key);

  @override
  _SalaButacaState createState() => _SalaButacaState();
}

class _SalaButacaState extends State<SalaButaca> {
  List<Butaca> seleccionadas = [];
  List<DocumentReference> referencias = [];
  late Sesion _sesion;
  final fb = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

//FALTA MIRAR EL PATH
  void _crearNuevaCollection() async {
    final batch = FirebaseFirestore.instance.batch();
    for (var x in widget.sesion.butaques) {
      final docRef = fb.doc(widget.path).collection('Butacas').doc('${x.num}');
      batch.set(docRef, x.toJson(), SetOptions(mergeFields: ['num']));
    }
    await batch.commit();
  }

  @override
  void initState() {
    _crearNuevaCollection();

    _sesion = widget.sesion;
    super.initState();
  }

  bool estoyPillada(Butaca n) => seleccionadas.contains(n);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selection Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
                height: 50,
                child: Text(
                  widget.titulo,
                  style: TextStyle(fontSize: 30),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: Text(
                '${_sesion.hora.hour}:${_sesion.hora.minute}',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: fb
                        .collection('${widget.path}/Butacas')
                        .orderBy('num')
                        .snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final docs = snapshot.data!.docs;
                      return GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8),
                        children: docs.map((document) {
                          Map<String, dynamic> data = document.data();
                          if (data['ocupada'] == null) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!Butaca.fromJson(data)
                                      .sonIguales(seleccionadas)) {
                                    seleccionadas.add(Butaca.fromJson(data));
                                    referencias.add(document.reference);
                                  } else {
                                    seleccionadas.removeWhere(
                                        (butaca) => butaca.num == data['num']);
                                    document.reference
                                        .update({'ocupada': null});
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  child: (!Butaca.fromJson(data)
                                          .sonIguales(seleccionadas)
                                      ? Image.asset(
                                          'assets/asiento-de-cine.png')
                                      : Image.asset('assets/cinema-seat.png')),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                child: Image.asset(
                                    'assets/asiento-de-cine-on.png'),
                              ),
                            );
                          }
                        }).toList(),
                      );
                    },
                  )),
            ),
          ),
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
                    color: Colors.white,
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
          GestureDetector(
            onTap: () {
              if (seleccionadas.isNotEmpty) {
                Navigator.of(context).pop([_sesion.hora, seleccionadas]);
                for (var r in referencias) {
                  r.update({'ocupada': _auth.currentUser!.email});
                }
              }
            },
            child: bottomRow(
              butaca: seleccionadas,
            ),
          )
        ],
      ),
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
