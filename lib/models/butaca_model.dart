import 'package:flutter/material.dart';

class Butaca {
  late int num;
  late String? ocupada;

  Butaca({
    required this.num,
    this.ocupada = null,
  });

  Butaca.fromJson(Map<String, dynamic> json)
      : this(
          num: json['num'],
          ocupada: json['ocupada'],
        );

  Map<String, dynamic> toJson() {
    return {
      'num': num,
      'ocupada': ocupada,
    };
  }
}
