import 'package:flutter/material.dart';
import '../../data/repository/movie_repository.dart';
import '../../data/models/movie.dart';
import '../details/movie_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({super.key});
  final MovieRepository repository;
  const HomeScreen({super.key, required this.repository});

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
    repository = widget.repository;
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
                // builder: (_) => MovieDetailsScreen(movie: movie),
                builder: (_) => MovieDetailsScreen(movie: movie, repository: repository),
              ),
            ),
            child: Container(
              width: 120,
              margin: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        height: 140,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: Icon(
                            repository.isBookmarked(movie.id)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                          ),
                          onPressed: () async {
                            if (repository.isBookmarked(movie.id)) {
                              await repository.removeBookmark(movie.id);
                            } else {
                              await repository.saveBookmark(movie);
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
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
    return ValueListenableBuilder(
      valueListenable: Hive.box('bookmarks').listenable(),
      builder: (context, Box box, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Movies App')),
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
      },
    );
  }
}