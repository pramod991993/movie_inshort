import 'package:dio/dio.dart';

import '../../core/constants.dart';

Dio createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    headers: {'accept': 'application/json'},
    queryParameters: {'api_key': apiKey},
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onError: (e, handler) async {
      final req = e.requestOptions;
      var retries = req.extra['retries'] as int? ?? 0;
      if (retries < 2) {
        req.extra['retries'] = retries + 1;
        try {
          final response = await dio.fetch(req);
          return handler.resolve(response);
        } catch (err) {
          return handler.next(err as DioException);
        }
      }
      return handler.next(e);
    },
  ));

  return dio;
}