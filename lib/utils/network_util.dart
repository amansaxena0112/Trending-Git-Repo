import 'dart:core';
import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkUtil {
  bool isProduction = bool.fromEnvironment('dart.vm.product');

  Uri getUri(String path, {Map<String, dynamic> queryParams: const {}}) {
    return Uri(
      host: 'ghapi.huchen.dev',
      path: path,
      scheme: 'https',
      queryParameters: queryParams,
    );
  }

  Future<http.Response> loadTrendingRepo() {
    print(getUri('/repositories'));
    return http.get(
      getUri('/repositories'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }
}
