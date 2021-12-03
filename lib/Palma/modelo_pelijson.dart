import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sesion_model.dart';

class Pelicula {
  late String titulo;
  late String id;
  late String info;
  late int duration;
  late List<dynamic> sesiones;
  late String asset;

  Pelicula({
    required this.titulo,
    required this.id,
    required this.info,
    required this.asset,
    required this.duration,
    required this.sesiones,
  });

  Pelicula.fromJson(Map<String, dynamic> json)
      : this(
          titulo: json["name"],
          id: json["id"],
          info: json["description"],
          asset: json["cover"],
          duration: json["duration"],
          sesiones: json["timetable"],
        );

  Map<String, dynamic> toJson() {
    return {
      "name": titulo,
      "id": id,
      "description": info,
      "cover": asset,
      "duration": duration,
      "timetable": sesiones,
    };
  }
}
