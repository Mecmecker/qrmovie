import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrmovie/models/butaca_model.dart';
import 'package:qrmovie/models/sesion_model.dart';
import 'package:qrmovie/widgets/bottom.dart';

class SalaScreen extends StatefulWidget {
  final String titulo;
  final Sesion sesion;
  final String path;
  const SalaScreen(
      {Key? key,
      required this.sesion,
      required this.titulo,
      required this.path})
      : super(key: key);

  @override
  _SalaScreenState createState() => _SalaScreenState();
}

class _SalaScreenState extends State<SalaScreen> {
  List<Butaca> seleccionadas = [];
  late Sesion _sesion;
  late String _path;
  final fb = FirebaseFirestore.instance;
//FALTA MIRAR EL PATH
  void _crearNuevaCollection() async {
    for (var x in widget.sesion.butaques)
      await fb.doc(widget.path).collection('Butacas').doc().set(x.toJson());
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
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    if (_sesion.butaques[index].ocupada == null)
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (estoyPillada(_sesion.butaques[index]) ==
                                  false) {
                                seleccionadas.add(_sesion.butaques[index]);
                              } else {
                                seleccionadas.removeWhere((butaca) =>
                                    butaca == _sesion.butaques[index]);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 6,
                              height: 6,
                              child: (estoyPillada(_sesion.butaques[index])
                                  ? Image.asset('assets/cinema-seat.png')
                                  : Image.asset('assets/asiento-de-cine.png')),
                            ),
                          ));
                    else {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          child: Image.asset('assets/asiento-de-cine-on.png'),
                        ),
                      );
                    }
                  },
                  itemCount: _sesion.butaques.length,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
              if (seleccionadas.isNotEmpty)
                Navigator.of(context).pop([_sesion.hora, seleccionadas]);
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
          color: this.color, borderRadius: BorderRadius.circular(6)),
    );
  }
}
