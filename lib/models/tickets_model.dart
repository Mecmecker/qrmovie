// ignore_for_file: non_constant_identifier_names

class Tickets {
  late String id_user, id_sesion;
  late int butaca;
  late DateTime dia;

  Tickets({
    required this.id_user,
    required this.id_sesion,
    required this.butaca,
    required this.dia,
  });
  Tickets.fromJson(Map<String, dynamic> json)
      : this(
          id_user: json["user_id"],
          id_sesion: json["sesion_id"],
          butaca: json["butaca"],
          dia: json['dia'].toDate(),
        );

  Map<String, dynamic> toJson() {
    return {
      "butaca": butaca,
      "sesion_id": id_sesion,
      "user_id": id_user,
      "dia": dia,
    };
  }
}
