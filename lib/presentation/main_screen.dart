import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/movie.dart';
import '../data/remote/api_service.dart';
import '../data/repository/movie_repository.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'details/movie_details_screen.dart';
import 'bookmarks/bookmarks_screen.dart';

class MainScreen extends StatefulWidget {
  // const MainScreen({super.key});
  final Movie? initialMovie;
  const MainScreen({super.key, this.initialMovie});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MovieRepository repository;
  int currentIndex = 0;
  late List<Widget> pages;
  Movie? deepLinkMovie;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.options.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmMzAzZDM2MTBhNGE0Y2FmN2UyMGMwMjgzODAwOWVkYyIsIm5iZiI6MTc1MjY2NDk3NS45ODcsInN1YiI6IjY4Nzc4YjhmNjJkYjIyZGYwNDc3OWEwOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Uda9p_MLy1aYZtOnGRTERCYsWK6O8aWWkc8N9vV3LGo';
    dio.options.headers['accept'] = 'application/json';
    final apiService = ApiService(dio);
    repository = MovieRepository(apiService);

    pages = [
      HomeScreen(repository: repository),
      SearchScreen(repository: repository),
      BookmarksScreen(repository: repository),
    ];
    deepLinkMovie = widget.initialMovie;
    if (deepLinkMovie != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(
              movie: deepLinkMovie!,
              repository: repository,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline), label: 'Bookmarks'),
        ],
      ),
    );
  }
}