import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/teacher_info.dart';
import 'package:solviolin/providers/client_state/teacher_state_provider.dart';

part 'teacher_info_list_provider.g.dart';

@riverpod
Future<List<TeacherInfo>> teacherInfoList(Ref ref, String branchName) async {
  if (branchName.isEmpty) {
    return [];
  }
  final teacherClient = ref.watch(teacherStateProvider);
  return await teacherClient.getTeacherInfos(branchName: branchName);
}
