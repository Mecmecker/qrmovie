import 'package:flutter/material.dart';

import 'butaca_model.dart';

class Sesion {
  late int numButaques;
  late List<Butaca> butaques;
  late TimeOfDay hora;

  Sesion({this.numButaques = 56, required this.hora}) {
    this.butaques = [
      for (int i = 1; i <= this.numButaques; i++) Butaca(num: i)
    ];
  }
}
