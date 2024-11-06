import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';
import 'package:solviolin_common/models/booking_status.dart';
import 'package:solviolin_common/models/dto/reservation_search_request.dart';
import 'package:solviolin_common/models/reservation.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin_common/providers/display_date_provider.dart';
import 'package:solviolin_common/providers/form/reservation_search_form_provider.dart';

part 'reservation_list_provider.g.dart';

@riverpod
Future<List<Reservation>> reservationList(Ref ref) async {
  final form = ref.watch(reservationSearchFormProvider);
  if (form.branchName.isEmpty) {
    return [];
  }

  final (start, end) = ref.watch(
    displayDateProvider.select((value) => (value.startOfWeek, value.endOfWeek)),
  );

  final reservationClient = ref.watch(reservationStateProvider);
  return await reservationClient.search(
    data: ReservationSearchRequest(
      branchName: form.branchName,
      startDate: start,
      endDate: end,
      teacherID: form.teacherID,
      userID: form.userID,
      bookingStatus: BookingStatus.valid,
    ),
  );
}
