class Tickets {
  late String id_user, id_sesion;
  late int butaca;

  Tickets({
    required this.id_user,
    required this.id_sesion,
    required this.butaca,
  });
  Tickets.fromJson(Map<String, dynamic> json)
      : this(
            id_user: json["user_id"],
            id_sesion: json["sesion_id"],
            butaca: json["butaca"]);

  Map<String, dynamic> toJson() {
    return {
      "butaca": this.butaca,
      "sesion_id": this.id_sesion,
      "user_id": this.id_user,
    };
  }
}
