import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/teacher_info.dart';
import 'package:solviolin_common/models/user.dart';
import 'package:solviolin_common/providers/teacher_info_list_provider.dart';

part 'teacher_info_provider.g.dart';

@riverpod
Future<TeacherInfo> teacherInfo(Ref ref, User user) async {
  final teacherInfoList =
      await ref.watch(teacherInfoListProvider(user.branchName).future);
  return teacherInfoList.firstWhere((e) => e.teacherID == user.userID);
}
