class Sesiones {
  late String cine, movieId, titol;
  late DateTime hora;
  late int duracion, numeroButacas;

  Sesiones({
    required this.cine,
    required this.movieId,
    required this.titol,
    required this.hora,
    required this.duracion,
    required this.numeroButacas,
  });

  Sesiones.fromJson(Map<String, dynamic> json)
      : this(
          cine: json['Cine'],
          movieId: json['MovieId'],
          titol: json['Titulo'],
          hora: json['Hora'].toDate(),
          duracion: json['Duracion'],
          numeroButacas: json['NumeroButacas'],
        );
}
