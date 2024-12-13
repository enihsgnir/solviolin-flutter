import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/providers/auth/access_token_provider.dart';

part 'is_sign_in_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool> isSignedIn(Ref ref) async {
  return ref.watch(
    accessTokenProvider.selectAsync((data) => data != null),
  );
}
