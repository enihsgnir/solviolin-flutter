import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/teacher.dart';
import 'package:solviolin/providers/client_state/teacher_state_provider.dart';
import 'package:solviolin/providers/form/teacher_search_form_provider.dart';

part 'teacher_list_provider.g.dart';

@riverpod
Future<List<Teacher>> teacherList(Ref ref) async {
  final form = ref.watch(teacherSearchFormProvider);

  final teacherClient = ref.watch(teacherStateProvider);
  final teacherList = await teacherClient.getAll(
    branchName: form.branchName,
    teacherID: form.teacherID,
  );
  return teacherList
    ..sort((a, b) {
      final teacherID = a.teacherID.compareTo(b.teacherID);
      if (teacherID != 0) return teacherID;

      final workDow = a.workDow.compareTo(b.workDow);
      if (workDow != 0) return workDow;

      final startTime = a.startTime.compareTo(b.startTime);
      if (startTime != 0) return startTime;

      return a.endTime.compareTo(b.endTime);
    });
}
