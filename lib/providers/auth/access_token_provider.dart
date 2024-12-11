import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/providers/secure_storage_provider.dart';

part 'access_token_provider.g.dart';

const String _key = "access_token";

@Riverpod(keepAlive: true)
class AccessToken extends _$AccessToken {
  @override
  Future<String?> build() async {
    final storage = ref.watch(storageProvider);
    return await storage.read(key: _key);
  }

  Future<void> setValue(String value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(storageProvider);
      await storage.write(key: _key, value: value);
      return value;
    });
  }

  Future<void> clear() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(storageProvider);
      await storage.delete(key: _key);
      return null;
    });
  }
}
