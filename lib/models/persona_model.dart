import 'package:qrmovie/models/butaca_model.dart';

class Persona {
  late String correo;
  late String nom;
  late List<Butaca> entradas;

  Persona({required this.nom, required this.correo, this.entradas = const []});
}
