import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Muestra extends StatelessWidget {
  const Muestra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseFirestore.instance;
    final pathBusquesda = fb
        .collection('/Peliculas/24001/Sesiones')
        .where('hora', isEqualTo: '20:30')
        .get();

    final path = '/Peliculas/24009';
    final busqueda = print(fb.collection('Peliculas').doc().parent);
    return Scaffold(
      appBar: AppBar(
        title: Text('nada'),
      ),
      body: StreamBuilder(
        stream: fb.doc(path).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data()!;
          return Column(
            children: [Text(data['id'])],
          );
        },
      ),
    );
  }
}
