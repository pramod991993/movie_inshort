import 'package:project_inshort/core/constants.dart';
import 'package:project_inshort/data/models/movieResponse.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/movie.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/trending/movie/day?language=en-US")
  Future<MovieResponse> getTrending();

  @GET("/movie/now_playing")
  Future<MovieResponse> getNowPlaying();

  @GET("/search/movie")
  Future<MovieResponse> searchMovies(
    @Query("query") String query,
  );
}
