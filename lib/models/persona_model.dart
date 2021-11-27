import 'package:qrmovie/models/butaca_model.dart';

class Persona {
  late String correo;
  late String? nom;
  late List<String> entradas;

  Persona({required this.nom, required this.correo, this.entradas = const []});
  Persona.fromJson(Map<String, dynamic> json)
      : this(
            correo: json["correo"],
            nom: json["nom"],
            entradas: json['entradas']);
  Map<String, dynamic> toJson() {
    return {
      "correo": correo,
      "nom": nom,
      "entradas": entradas,
    };
  }
}
