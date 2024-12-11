import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/extensions/date_time_extension.dart';
import 'package:solviolin/models/dto/control_search_request.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/providers/branch_list_provider.dart';
import 'package:solviolin/providers/client_state/control_state_provider.dart';
import 'package:solviolin/providers/client_state/teacher_state_provider.dart';
import 'package:solviolin/providers/display_date_provider.dart';
import 'package:solviolin/providers/form/reservation_search_form_provider.dart';
import 'package:solviolin/providers/profile_provider.dart';
import 'package:solviolin/providers/teacher_info_list_provider.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/utils/time_region.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

part 'reservation_time_regions_provider.g.dart';

@riverpod
Future<List<TimeRegion>> timeRegions(Ref ref) async {
  final (start, end) = ref.watch(
    displayDateProvider.select((value) => (value.startOfWeek, value.endOfWeek)),
  );

  final profile = await ref.watch(profileProvider.future);

  final teacherClient = ref.watch(teacherStateProvider);

  switch (profile.userType) {
    case UserType.student:
      return [];

    case UserType.teacher:
      final teacherID = profile.userID;

      final teachers = await teacherClient.getAll(teacherID: teacherID);

      final branchList = await ref.watch(branchListProvider.future);

      final controlClient = ref.watch(controlStateProvider);
      final result = await Future.wait([
        for (final branchName in branchList)
          controlClient.search(
            data: ControlSearchRequest(
              branchName: branchName,
              teacherID: teacherID,
              controlStart: start,
              controlEnd: end,
            ),
          ),
      ]);
      final controls = result.expand((e) => e).toList();

      return calculateTimeRegions(
        startOfWeek: start,
        teachers: teachers,
        controls: controls,
        colors: {teacherID: green},
      );

    case UserType.admin:
      final form = ref.watch(reservationSearchFormProvider);

      final branchName = form.branchName;
      if (branchName.isEmpty) {
        return [];
      }

      final teacherID = form.teacherID;

      final teachers = await teacherClient.getAll(
        branchName: branchName,
        teacherID: teacherID,
      );

      final controlClient = ref.watch(controlStateProvider);
      final controls = await controlClient.search(
        data: ControlSearchRequest(
          branchName: branchName,
          teacherID: teacherID,
          controlStart: start,
          controlEnd: end,
        ),
      );

      final teacherInfos =
          await ref.watch(teacherInfoListProvider(branchName).future);
      final teacherColorMap = {
        for (final info in teacherInfos) info.teacherID: info.color,
      };

      return calculateTimeRegions(
        startOfWeek: start,
        teachers: teachers,
        controls: controls,
        colors: teacherColorMap,
      );
  }
}
