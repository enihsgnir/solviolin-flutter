import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/providers/client_state/branch_state_provider.dart';
import 'package:solviolin/providers/client_state/teacher_state_provider.dart';
import 'package:solviolin/providers/profile_provider.dart';

part 'branch_list_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> branchList(Ref ref) async {
  final profile = await ref.watch(profileProvider.future);

  switch (profile.userType) {
    case UserType.student:
      return [];

    case UserType.teacher:
      final teacherClient = ref.watch(teacherStateProvider);
      final teachers = await teacherClient.getAll(teacherID: profile.userID);
      return teachers.map((e) => e.branchName).toSet().toList();

    case UserType.admin:
      final branchClient = ref.watch(branchStateProvider);
      final branches = await branchClient.getAll();
      return branches.map((e) => e.branchName).toList();
  }
}
