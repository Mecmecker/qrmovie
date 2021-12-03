import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Muestra extends StatelessWidget {
  const Muestra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseFirestore.instance;
    final p = '/Peliculas/24001/Sesiones/54RVJD6rmgeMzpQHfyNk';

    final path = '/Peliculas/24009';
    final busqueda = print(fb.collection('Peliculas').doc().parent);
    return Scaffold(
      appBar: AppBar(
        title: Text('nada'),
      ),
      body: StreamBuilder(
        stream: fb
            .doc(p)
            .collection('Butacas')
            .orderBy('num', descending: false)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              Map<String, dynamic> data = document.data();
              return Text('${data['num']}');
            }).toList(),
          );
        },
      ),
    );
  }
}
