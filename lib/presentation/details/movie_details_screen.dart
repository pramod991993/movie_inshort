import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_inshort/data/repository/movie_repository.dart';
import '../../data/models/movie.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  // const MovieDetailsScreen({super.key, required this.movie});
 final MovieRepository repository;
  const MovieDetailsScreen({super.key, required this.movie, required this.repository});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late bool bookmarked;
  @override
  
  Widget build(BuildContext context) {
    bookmarked = widget.repository.isBookmarked(widget.movie.id);
    return Scaffold(
      // appBar: AppBar(title: Text(movie.title)),
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [
          IconButton(
            icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () async {
              if (bookmarked) {
                await widget.repository.removeBookmark(widget.movie.id);
              } else {
                await widget.repository.saveBookmark(widget.movie);
              }
              setState(() {
                bookmarked = widget.repository.isBookmarked(widget.movie.id);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final data =
                  base64Url.encode(utf8.encode(jsonEncode(widget.movie.toJson())));
              final link = 'https://movieapp.example/?movie=$data';
              // final link = 'movieapp://?movie=$data';
              Share.share('Check out ${widget.movie.title}: $link');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // if (movie.posterPath != null)
              //   Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath!}'),
              if (widget.movie.posterPath != null)
              //   Image.network('https://image.tmdb.org/t/p/w500${widget.movie.posterPath!}'),
                CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath!}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                // Image.network('https://image.tmdb.org/t/p/w500${widget.movie.posterPath!}'),
              const SizedBox(height: 16),
              // Text(movie.overview),
              Text(widget.movie.overview),
            ],
          ),
        ),
      ),
    );
  }
}