import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';
import 'package:solviolin_common/models/booking_status.dart';
import 'package:solviolin_common/models/dto/reservation_search_request.dart';
import 'package:solviolin_common/models/reservation.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin_common/providers/focused_day_provider.dart';
import 'package:solviolin_common/providers/profile_provider.dart';

part 'my_valid_reservations_provider.g.dart';

@riverpod
Future<List<Reservation>> myValidReservations(Ref ref) async {
  final profile = await ref.watch(profileProvider.future);

  final (start, end) = ref.watch(
    focusedDayProvider.select((value) {
      final firstDay = DateTime(value.year, value.month);
      final start = firstDay.startOfWeek;

      final lastDay = DateTime(value.year, value.month + 1, 0);
      final end = lastDay.endOfWeek;

      return (start, end);
    }),
  );

  final reservationClient = ref.watch(reservationStateProvider);
  return await reservationClient.search(
    data: ReservationSearchRequest(
      branchName: profile.branchName,
      startDate: start,
      endDate: end,
      userID: profile.userID,
      bookingStatus: BookingStatus.valid,
    ),
  );
}
