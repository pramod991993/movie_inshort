import 'package:hive/hive.dart';
import '../models/movie.dart';
import '../remote/api_service.dart';
import '../../core/constants.dart';

class MovieRepository {
  final ApiService apiService;

  MovieRepository(this.apiService);

  Future<List<Movie>> getTrending() async {
    final result = await apiService.getTrending();
    // print(result);
    return result.results;
    // return movies.map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Movie>> getNowPlaying() async {
    final result = await apiService.getNowPlaying();
    // final List movies = result.results;
    return result.results;
    // return movies.map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Movie>> search(String query) async {
    final result = await apiService.searchMovies( query);
    return result.results;
    // final List movies = result.results;
    // return movies.map((e) => Movie.fromJson(e)).toList();
  }

  Future<void> saveBookmark(Movie movie) async {
    final box = Hive.box("bookmarks");
    box.put(movie.id, movie.toJson());
  }

  List<Movie> getBookmarks() {
    final box = Hive.box("bookmarks");
    return box.values.map((e) => Movie.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> removeBookmark(int id) async {
    final box = Hive.box("bookmarks");
    await box.delete(id);
  }

  bool isBookmarked(int id) {
    final box = Hive.box("bookmarks");
    return box.containsKey(id);
  }
}