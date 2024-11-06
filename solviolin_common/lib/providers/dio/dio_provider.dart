import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/providers/dio/auth_interceptor_provider.dart';
import 'package:solviolin_common/utils/env.dart';
import 'package:solviolin_common/utils/log_interceptor.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio()
    // `retrofit` combines `Dio.options.baseUrl` and `RestApi.baseUrl`
    // using `Uri.resolveUri` method. To merge the two URLs correctly,
    // `RestApi.baseUrl` should not start with a leading slash.
    ..options.baseUrl = baseUrl;

  final authInterceptor = ref.watch(authInterceptorProvider(dio));
  dio.interceptors.add(authInterceptor);

  dio.interceptors.add(const CustomLogInterceptor());

  return dio;
}
