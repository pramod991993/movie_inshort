import 'package:json_annotation/json_annotation.dart';
import 'movie.dart';

part 'movieResponse.g.dart';

@JsonSerializable()
class MovieResponse {
  final List<Movie> results;

  MovieResponse({required this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}