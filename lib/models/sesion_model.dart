import 'dart:convert';

import 'package:flutter/material.dart';

import 'butaca_model.dart';

class Sesion {
  late int numButaques;
  late List<Butaca> butaques;
  late TimeOfDay hora;

  Sesion(
      {this.numButaques = 56, required this.hora, this.butaques = const []}) {
    if (this.butaques.isEmpty)
      this.butaques = [
        for (int i = 1; i <= this.numButaques; i++) Butaca(num: i)
      ];
  }

  Sesion.fromJson(Map<String, dynamic> json)
      : this(
            numButaques: json['numButaques'],
            hora: json['hora'],
            butaques: json['butaques']);

  Map<String, dynamic> toJson() {
    return {
      "numButaques": numButaques,
      "hora": hora,
      "butaques": butaques,
    };
  }
}
