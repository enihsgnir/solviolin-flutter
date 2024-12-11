import 'package:dio/dio.dart';

extension DioExceptionDescriptionExtension on DioException {
  bool get isTimeout =>
      type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout;

  String? get description {
    if (isTimeout) {
      return "연결 시간이 초과했습니다\n다시 시도해주세요";
    }

    final status = response?.statusCode?.toString();
    if (status == null) {
      return null;
    }

    final message = requestOptions.extra[status];
    if (message == null) {
      return null;
    }

    return message.toString();
  }
}
