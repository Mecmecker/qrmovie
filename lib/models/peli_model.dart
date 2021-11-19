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

  Peli.fromJson(Map<String, dynamic> json)
      : this(
            titulo: json["titulo"],
            info: json["info"],
            sesiones: json["sesiones"],
            asset: json["asset"]);

  Map<String, dynamic> toJson() {
    return {
      "titulo": titulo,
      "info": info,
      "sesiones": sesiones,
      "asset": asset,
    };
  }
}
