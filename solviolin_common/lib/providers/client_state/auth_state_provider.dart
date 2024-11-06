import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/clients/auth_client.dart';
import 'package:solviolin_common/providers/auth/access_token_provider.dart';
import 'package:solviolin_common/providers/auth/refresh_token_provider.dart';
import 'package:solviolin_common/providers/dio/dio_provider.dart';
import 'package:solviolin_common/providers/is_sign_in_provider.dart';
import 'package:solviolin_common/providers/router_provider.dart';
import 'package:solviolin_common/utils/exceptions.dart';

part 'auth_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  AuthClient build() {
    final dio = ref.watch(dioProvider);
    return AuthClient(dio);
  }

  Future<void> signIn({
    required String userID,
    required String userPassword,
  }) async {
    final auth = await state.signIn(
      userID: userID,
      userPassword: userPassword,
    );

    await ref.read(accessTokenProvider.notifier).setValue(auth.accessToken);
    await ref.read(refreshTokenProvider.notifier).setValue(auth.refreshToken);
  }

  Future<void> refresh() async {
    final refreshToken = await ref.read(refreshTokenProvider.future);
    if (refreshToken == null) {
      throw const TokenRefreshException();
    }

    try {
      await ref.read(accessTokenProvider.notifier).clear();

      final auth = await state.refresh(refreshToken);
      await ref.read(accessTokenProvider.notifier).setValue(auth.accessToken);
    } on DioException catch (_) {
      throw const TokenRefreshException();
    }
  }

  Future<void> signOut() async {
    try {
      final isSignedIn = await ref.read(isSignedInProvider.future);
      if (isSignedIn) {
        await state.signOut();
      }
    } on DioException catch (_) {
    } finally {
      await ref.read(accessTokenProvider.notifier).clear();
      await ref.read(refreshTokenProvider.notifier).clear();

      // invalidate `profileProvider` indirectly
      ref.invalidateSelf();

      ref.read(routerProvider).go("/sign-in");
    }
  }
}
