import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:solviolin/utils/logger.dart';

const JsonEncoder _encoder = JsonEncoder.withIndent("  ");
const String _timestampKey = "_log_timestamp_";

class CustomLogInterceptor extends Interceptor {
  const CustomLogInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final buffer = StringBuffer();

    buffer.writeHeaderLine("Request", options);
    buffer.writeHeaders(options.headers);
    buffer.writeExtra(options.extra);
    buffer.writeBody(options.data);

    logger.d(buffer.toString());

    options.extra[_timestampKey] = DateTime.timestamp().millisecondsSinceEpoch;

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final buffer = StringBuffer();

    final options = response.requestOptions;
    buffer.writeHeaderLine("Response", options, response);
    buffer.writeHeaders(response.headers.map);
    buffer.writeBody(response.data);

    logger.d(buffer.toString());

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final buffer = StringBuffer();

    final type = err.type;
    final options = err.requestOptions;
    final response = err.response;
    if (type == DioExceptionType.badResponse && response != null) {
      buffer.writeHeaderLine("DioError", options, response);
      buffer.writeBody(response.data);
    } else {
      buffer.writeHeaderLine("DioError-$type", options);
      buffer.writeln(err.message);
    }

    logger.e(buffer.toString());

    handler.next(err);
  }
}

String _getPath(Uri uri) {
  final path = uri.path;

  final query = uri.query;
  if (query.isEmpty) {
    return path;
  }

  final decodedQuery = Uri.decodeQueryComponent(query);
  return "$path?$decodedQuery";
}

int? _getDiff(Map<String, dynamic> extra) {
  final requestTime = extra[_timestampKey] as int?;
  if (requestTime == null) {
    return null;
  }
  return DateTime.timestamp().millisecondsSinceEpoch - requestTime;
}

extension on StringBuffer {
  void writeHeaderLine(
    String prefix,
    RequestOptions options, [
    Response? response,
  ]) {
    write(prefix);

    if (response != null) {
      final statusCode = response.statusCode;
      write(" | $statusCode");
    }

    final method = options.method;
    final path = _getPath(options.uri);
    write(" | $method $path");

    if (response != null) {
      final diff = _getDiff(options.extra) ?? 0;
      write(" | Time: $diff ms");
    }

    writeln();
  }

  void writeHeaders(Map<String, dynamic> headers) {
    if (headers.isNotEmpty) {
      writeln("\n[Headers]");
      for (final MapEntry(:key, :value) in headers.entries) {
        writeln("$key: $value");
      }
    }
  }

  void writeExtra(Map<String, dynamic> extra) {
    if (extra.isNotEmpty) {
      writeln("\n[Extra]");
      for (final MapEntry(:key, :value) in extra.entries) {
        writeln("$key: $value");
      }
    }
  }

  void writeBody(dynamic data) {
    if (data != null) {
      writeln("\n[Body]");
      writeln(_encoder.convert(data));
    }
  }
}
