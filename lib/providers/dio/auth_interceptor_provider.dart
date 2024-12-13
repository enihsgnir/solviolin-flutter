import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/extensions/auth_header_extension.dart';
import 'package:solviolin/extensions/request_type_extension.dart';
import 'package:solviolin/providers/auth/access_token_provider.dart';
import 'package:solviolin/providers/client_state/auth_state_provider.dart';
import 'package:solviolin/utils/exceptions.dart';

part 'auth_interceptor_provider.g.dart';

@riverpod
Interceptor authInterceptor(Ref ref, Dio dio) {
  bool isRefreshing = false;
  final retryQueue = <(RequestOptions, ErrorInterceptorHandler)>[];

  Future<void> retry((RequestOptions, ErrorInterceptorHandler) request) async {
    final (options, handler) = request;

    try {
      final response = await dio.fetch(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    } catch (e, s) {
      final error = DioException(
        requestOptions: options,
        error: e,
        stackTrace: s,
      );
      return handler.next(error);
    }
  }

  Future<void> reject((RequestOptions, ErrorInterceptorHandler) request) async {
    final (options, handler) = request;
    return handler.next(DioException(requestOptions: options));
  }

  Future<void> handleUnauthorized(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    retryQueue.add((options, handler));
    if (isRefreshing) {
      return;
    }

    try {
      isRefreshing = true;
      await ref.read(authStateProvider.notifier).refresh();
      await Future.wait(retryQueue.map(retry));
    } on TokenRefreshException catch (_) {
      await ref.read(authStateProvider.notifier).signOut();
      await Future.wait(retryQueue.map(reject));
    } finally {
      retryQueue.clear();
      isRefreshing = false;
    }
  }

  return InterceptorsWrapper(
    onRequest: (options, handler) async {
      final accessToken = await ref.read(accessTokenProvider.future);
      return handler.next(options..accessToken = accessToken);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        final options = error.requestOptions;

        if (options.isSignInRequest || options.isTokenRefreshRequest) {
          return handler.next(error);
        }

        return await handleUnauthorized(options, handler);
      }

      return handler.next(error);
    },
  );
}
