import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/clients/check_in_client.dart';
import 'package:solviolin/providers/dio/dio_provider.dart';

part 'check_in_state_provider.g.dart';

@Riverpod(keepAlive: true)
class CheckInState extends _$CheckInState {
  @override
  CheckInClient build() {
    final dio = ref.watch(dioProvider);
    return CheckInClient(dio);
  }

  Future<void> checkIn(String branchCode) async {
    await state.checkIn(branchCode);
  }
}
