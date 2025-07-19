import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import 'dart:async';
import '../../data/repository/movie_repository.dart';
import '../details/movie_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  final MovieRepository repository;
  const SearchScreen({super.key, required this.repository});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> results = [];
  final TextEditingController controller = TextEditingController();
  bool loading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _search);
  }

  Future<void> _search() async {
    final query = controller.text.trim();
    if (query.isEmpty) return;
    setState(() {
      loading = true;
    });
    try {
      results = await widget.repository.search(query);
    } catch (e) {
      results = [];
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search movies...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          if (loading) const CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final movie = results[index];
                return ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: movie.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : null,
                  title: Text(movie.title),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsScreen(movie: movie, repository: widget.repository,),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}