import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/control.dart';
import 'package:solviolin_common/models/dto/control_search_request.dart';
import 'package:solviolin_common/models/user_type.dart';
import 'package:solviolin_common/providers/branch_list_provider.dart';
import 'package:solviolin_common/providers/client_state/control_state_provider.dart';
import 'package:solviolin_common/providers/form/control_search_form_provider.dart';
import 'package:solviolin_common/providers/profile_provider.dart';

part 'control_list_provider.g.dart';

@riverpod
Future<List<Control>> controlList(Ref ref) async {
  final profile = await ref.watch(profileProvider.future);
  switch (profile.userType) {
    case UserType.student:
      return [];

    case UserType.teacher:
      final branchList = await ref.watch(branchListProvider.future);

      final controlClient = ref.watch(controlStateProvider);
      final result = await Future.wait([
        for (final branchName in branchList)
          controlClient.search(
            data: ControlSearchRequest(
              branchName: branchName,
              teacherID: profile.userID,
            ),
          ),
      ]);
      return result.expand((e) => e).toList()
        ..sort((a, b) => b.controlStart.compareTo(a.controlStart));

    case UserType.admin:
      const endOffset = Duration(days: 1);

      final form = ref.watch(controlSearchFormProvider);

      final controlClient = ref.watch(controlStateProvider);
      final controlList = await controlClient.search(
        data: ControlSearchRequest(
          branchName: form.branchName,
          teacherID: form.teacherID,
          controlStart: form.controlStart,
          controlEnd: form.controlEnd.add(endOffset),
          status: form.status,
        ),
      );
      return controlList
        ..sort((a, b) => b.controlStart.compareTo(a.controlStart));
  }
}
