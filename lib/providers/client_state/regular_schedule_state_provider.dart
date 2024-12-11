import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/clients/regular_schedule_client.dart';
import 'package:solviolin/providers/dio/dio_provider.dart';

part 'regular_schedule_state_provider.g.dart';

@Riverpod(keepAlive: true)
class RegularScheduleState extends _$RegularScheduleState {
  @override
  RegularScheduleClient build() {
    final dio = ref.watch(dioProvider);
    return RegularScheduleClient(dio);
  }

  Future<void> delete(int id) async {
    await state.delete(id);
  }
}
