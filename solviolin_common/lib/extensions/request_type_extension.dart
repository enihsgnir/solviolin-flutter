import 'package:dio/dio.dart';

extension RequestTypeExtension on RequestOptions {
  bool get isSignInRequest => extra["type"] == "sign_in";

  bool get isTokenRefreshRequest => extra["type"] == "token_refresh";
}
