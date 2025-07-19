import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_inshort/data/models/movie.dart';
import 'package:project_inshort/presentation/home/home_screen.dart';
import 'package:project_inshort/presentation/main_screen.dart';
import 'data/models/movie.dart';

Future<void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await Hive.initFlutter();
  await Hive.openBox('bookmarks');
  await Hive.openBox('cache');
  // runApp(const MyApp());
   Movie? deepLinkedMovie;
  final movieParam = Uri.base.queryParameters['movie'];
  if (movieParam != null) {
    try {
      final jsonStr = utf8.decode(base64Url.decode(movieParam));
      deepLinkedMovie = Movie.fromJson(jsonDecode(jsonStr));
    } catch (_) {}
  }

  runApp(MyApp(initialMovie: deepLinkedMovie));
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});
  final Movie? initialMovie;
  const MyApp({super.key, this.initialMovie});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    //  title: 'Movies DB',
     title: 'Movies DB',
      theme: ThemeData.dark(),
      // home: const HomeScreen(),
      // home: const MainScreen(),
      home: MainScreen(initialMovie: initialMovie),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
    client.findProxy = (uri) => "DIRECT";
    return client;
  }
}
