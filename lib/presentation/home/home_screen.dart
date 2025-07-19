import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/remote/api_service.dart';
import '../../data/repository/movie_repository.dart';
import '../../data/models/movie.dart';
import '../details/movie_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieRepository repository;
  List<Movie> trending = [];
  List<Movie> nowPlaying = [];

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMzAzZDM2MTBhNGE0Y2FmN2UyMGMwMjgzODAwOWVkYyIsIm5iZiI6MTc1MjY2NDk3NS45ODcsInN1YiI6IjY4Nzc4YjhmNjJkYjIyZGYwNDc3OWEwOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Uda9p_MLy1aYZtOnGRTERCYsWK6O8aWWkc8N9vV3LGo'; 
    dio.options.headers['accept'] = 'application/json';
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    final apiService = ApiService(dio);
    repository = MovieRepository(apiService);
    fetchMovies();
  }

  void fetchMovies() async {
    int retries = 3;
    while (retries > 0) {
      try {
        trending = await repository.getTrending();
        await Future.delayed(const Duration(milliseconds: 500));
        nowPlaying = await repository.getNowPlaying();
        setState(() {});
        break; // Success!
      } catch (e) {
        retries--;
        if (retries == 0) {
          // Show error to user
          print('Failed after retries: $e');
        } else {
          await Future.delayed(Duration(seconds: 1));
        }
      }
    }
    // trending = await repository.getTrending();
    // nowPlaying = await repository.getNowPlaying();
    // setState(() {});
  }

  Widget buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailsScreen(movie: movie),
              ),
            ),
            child: Container(
              width: 120,
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 140,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  // Image.network(
                  //   'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  //   height: 140,
                  //   fit: BoxFit.cover,
                  // ),
                  Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies DB')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Trending', style: TextStyle(fontSize: 18)),
            ),
            buildMovieList(trending),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Now Playing', style: TextStyle(fontSize: 18)),
            ),
            buildMovieList(nowPlaying),
          ],
        ),
      ),
    );
  }
}