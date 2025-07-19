import 'package:flutter/material.dart';
import '../../data/models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.posterPath != null)
                Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath!}'),
              const SizedBox(height: 16),
              Text(movie.overview),
            ],
          ),
        ),
      ),
    );
  }
}