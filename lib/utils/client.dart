import 'package:dio/dio.dart';

const baseUrl = "https://xn--sy2bt7bxwhpof3wb.com";

final dio = Dio()
  ..options.connectTimeout = const Duration(seconds: 75)
  ..options.receiveTimeout = const Duration(seconds: 40);
