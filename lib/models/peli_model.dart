import 'sesion_model.dart';

class Peli {
  late String titulo;
  late String info;
  late List<Sesion> sesiones;
  String? asset;

  Peli(
      {required this.titulo,
      required this.info,
      required this.sesiones,
      this.asset = null});
}
