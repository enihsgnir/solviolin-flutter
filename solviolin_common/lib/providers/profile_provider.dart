import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/profile.dart';
import 'package:solviolin_common/providers/client_state/auth_state_provider.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Profile> profile(Ref ref) async {
  final authClient = ref.watch(authStateProvider);
  return await authClient.getProfile();
}
