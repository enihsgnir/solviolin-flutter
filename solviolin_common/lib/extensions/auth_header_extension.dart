import 'package:dio/dio.dart';

extension AuthHeaderExtension on RequestOptions {
  set accessToken(String? value) {
    if (value != null) {
      headers["Authorization"] = "Bearer $value";
    } else {
      headers.remove("Authorization");
    }
  }
}
