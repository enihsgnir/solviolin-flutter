import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/canceled.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin/providers/form/canceled_search_form_provider.dart';
import 'package:solviolin/providers/profile_provider.dart';

part 'canceled_list_provider.g.dart';

@riverpod
Future<List<Canceled>> canceledList(Ref ref) async {
  final profile = await ref.watch(profileProvider.future);

  final reservationClient = ref.watch(reservationStateProvider);

  switch (profile.userType) {
    case UserType.student:
      return [];

    case UserType.teacher:
      return await reservationClient.getAllCanceled(teacherID: profile.userID);

    case UserType.admin:
      final form = ref.watch(canceledSearchFormProvider);
      return await reservationClient.getAllCanceled(teacherID: form.teacherID);
  }
}
