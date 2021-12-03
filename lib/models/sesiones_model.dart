import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Sesiones {
  late String cine, movieId;
  late DateTime hora;
  late int duracion, numeroButacas;

  Sesiones({
    required this.cine,
    required this.movieId,
    required this.hora,
    required this.duracion,
    required this.numeroButacas,
  });

  Sesiones.fromJson(Map<String, dynamic> json)
      : this(
          cine: json['Cine'],
          movieId: json['MovieId'],
          hora: json['Hora'].toDate(),
          duracion: json['Duracion'],
          numeroButacas: json['NumeroButacas'],
        );
}
