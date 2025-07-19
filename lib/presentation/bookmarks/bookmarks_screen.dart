import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/repository/movie_repository.dart';
import '../details/movie_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class BookmarksScreen extends StatefulWidget {
  final MovieRepository repository;
  const BookmarksScreen({super.key, required this.repository});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  // late List<Movie> bookmarks;

  // @override
  // void initState() {
  //   super.initState();
  //   bookmarks = widget.repository.getBookmarks();
  //   print(bookmarks.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      // body: bookmarks.isEmpty
      //     ? const Center(child: Text('No bookmarks'))
      //     : ListView.builder(
      //         itemCount: bookmarks.length,
      //         itemBuilder: (context, index) {
      //           final movie = bookmarks[index];
      //           return ListTile(
      //             leading: movie.posterPath != null
      //                 ? CachedNetworkImage(
      //                     imageUrl: 'https://image.tmdb.org/t/p/w92${movie.posterPath}',
      //                     width: 50,
      //                     fit: BoxFit.cover,
      //                   )
      //                 : null,
      //             title: Text(movie.title),
      //             onTap: () => Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (_) => MovieDetailsScreen(movie: movie,repository: widget.repository,),
      //               ),
      //             ).then((_) => setState(() {
      //                   bookmarks = widget.repository.getBookmarks();
      //                 })),
      //             trailing: IconButton(
      //               icon: const Icon(Icons.delete_outline),
      //               onPressed: () async {
      //                 await widget.repository.removeBookmark(movie.id);
      //                 setState(() {
      //                   bookmarks = widget.repository.getBookmarks();
      //                 });
      //               },
      //             ),
      //           );
      //         },
      //       ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('bookmarks').listenable(),
        builder: (context, Box box, _) {
          final List<Movie> bookmarks = box.values
              .map((e) => Movie.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          if (bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarks'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all( 8.0),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final movie = bookmarks[index];
              return ListTile(
                contentPadding: EdgeInsets.all(8),
                 trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await widget.repository.removeBookmark(movie.id);
                  },
                ),
                leading: movie.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : null,
                title: Text(movie.title),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailsScreen(
                      movie: movie,
                      repository: widget.repository,
                    ),
                
             ))  
            );
          },
        );
        },
      ),
    );

  }
}