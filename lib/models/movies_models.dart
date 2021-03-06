import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  late String nom, poster, info;
  late int duracion, id;
  late double rate;
  late List<dynamic> generos;

  Movie({
    required this.nom,
    required this.id,
    required this.poster,
    required this.info,
    required this.duracion,
    required this.rate,
    required this.generos,
  });
  Movie.fromJson(Map<String, dynamic> json)
      : this(
            nom: json['original_title'],
            id: json['id'],
            poster: json['poster_path'],
            info: json['overview'],
            duracion: json['runtime'],
            rate: json["vote_average"],
            generos: json["genres"]);
}

Future<Movie> loadFilms(path) async {
  final uri = Uri.parse(path);
  final response = await http.get(uri);
  final json = jsonDecode(response.body);
  return Movie.fromJson(json);
}
