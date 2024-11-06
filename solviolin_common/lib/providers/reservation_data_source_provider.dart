import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';
import 'package:solviolin_common/models/booking_status.dart';
import 'package:solviolin_common/models/dto/reservation_search_request.dart';
import 'package:solviolin_common/models/teacher_color.dart';
import 'package:solviolin_common/models/teacher_info.dart';
import 'package:solviolin_common/models/user_type.dart';
import 'package:solviolin_common/providers/branch_list_provider.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin_common/providers/display_date_provider.dart';
import 'package:solviolin_common/providers/form/reservation_search_form_provider.dart';
import 'package:solviolin_common/providers/profile_provider.dart';
import 'package:solviolin_common/providers/reservation_list_provider.dart';
import 'package:solviolin_common/providers/teacher_info_list_provider.dart';
import 'package:solviolin_common/utils/data_source.dart';

part 'reservation_data_source_provider.g.dart';

@riverpod
Future<ReservationDataSource?> dataSource(Ref ref) async {
  final profile = await ref.watch(profileProvider.future);
  switch (profile.userType) {
    case UserType.student:
      return null;

    case UserType.teacher:
      final (start, end) = ref.watch(
        displayDateProvider
            .select((value) => (value.startOfWeek, value.endOfWeek)),
      );

      final teacherInfoList =
          await ref.watch(teacherInfoListProvider(profile.branchName).future);

      final teacherID = profile.userID;
      final teacherInfo = teacherInfoList.firstWhere(
        (e) => e.teacherID == teacherID,
        orElse: () => TeacherInfo(
          teacherID: teacherID,
          teacher: const TeacherColor(),
        ),
      );

      final branchList = await ref.watch(branchListProvider.future);

      final reservationClient = ref.watch(reservationStateProvider);
      final result = await Future.wait([
        for (final branchName in branchList)
          reservationClient.search(
            data: ReservationSearchRequest(
              branchName: branchName,
              teacherID: teacherID,
              startDate: start,
              endDate: end,
              bookingStatus: BookingStatus.valid,
            ),
          ),
      ]);
      final reservations = result.expand((e) => e).toList();

      return ReservationDataSource(
        reservations: reservations,
        teacherInfos: [teacherInfo],
      );

    case UserType.admin:
      final form = ref.watch(reservationSearchFormProvider);
      if (form.branchName.isEmpty) {
        return null;
      }

      final reservationList = await ref.watch(reservationListProvider.future);
      final teacherInfoList =
          await ref.watch(teacherInfoListProvider(form.branchName).future);
      return ReservationDataSource(
        reservations: reservationList,
        teacherInfos: teacherInfoList,
      );
  }
}
