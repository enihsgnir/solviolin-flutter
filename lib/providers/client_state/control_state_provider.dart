import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/clients/control_client.dart';
import 'package:solviolin/models/cancel_in_close.dart';
import 'package:solviolin/models/control_status.dart';
import 'package:solviolin/models/dto/control_register_request.dart';
import 'package:solviolin/providers/dio/dio_provider.dart';

part 'control_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ControlState extends _$ControlState {
  @override
  ControlClient build() {
    final dio = ref.watch(dioProvider);
    return ControlClient(dio);
  }

  Future<void> register({
    required String teacherID,
    required String branchName,
    required DateTime controlStart,
    required DateTime controlEnd,
    required ControlStatus status,
    required CancelInClose cancelInClose,
  }) async {
    final data = ControlRegisterRequest(
      branchName: branchName,
      teacherID: teacherID,
      controlStart: controlStart,
      controlEnd: controlEnd,
      status: status,
      cancelInClose: cancelInClose,
    );
    await state.register(data: data);
  }

  Future<void> delete(int id) async {
    await state.delete(id);
  }
}
