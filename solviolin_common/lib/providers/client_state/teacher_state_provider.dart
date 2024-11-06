import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/clients/teacher_client.dart';
import 'package:solviolin_common/models/dto/teacher_register_request.dart';
import 'package:solviolin_common/providers/dio/dio_provider.dart';

part 'teacher_state_provider.g.dart';

@Riverpod(keepAlive: true)
class TeacherState extends _$TeacherState {
  @override
  TeacherClient build() {
    final dio = ref.watch(dioProvider);
    return TeacherClient(dio);
  }

  Future<void> register({
    required String teacherID,
    required String teacherBranch,
    required int workDow,
    required Duration startTime,
    required Duration endTime,
  }) async {
    final data = TeacherRegisterRequest(
      teacherID: teacherID,
      teacherBranch: teacherBranch,
      workDow: workDow,
      startTime: startTime,
      endTime: endTime,
    );
    await state.register(data: data);
  }

  Future<void> delete(int id) async {
    await state.delete(id);
  }
}
