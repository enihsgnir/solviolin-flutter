import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/booking_status.dart';
import 'package:solviolin/models/dto/reservation_search_request.dart';
import 'package:solviolin/models/reservation.dart';
import 'package:solviolin/models/term_position.dart';
import 'package:solviolin/models/user.dart';
import 'package:solviolin/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin/providers/profile_provider.dart';
import 'package:solviolin/providers/term_range_provider.dart';

part 'term_reservations_provider.g.dart';

@riverpod
Future<List<Reservation>> termReservations(
  Ref ref, {
  required User? user,
  required TermPosition position,
}) async {
  final termRange = await ref.watch(termRangeProvider.future);
  final term = termRange.at(position);

  final reservationClient = ref.watch(reservationStateProvider);

  if (user == null) {
    final profile = await ref.watch(profileProvider.future);
    return await reservationClient.search(
      data: ReservationSearchRequest(
        branchName: profile.branchName,
        startDate: term.termStart,
        endDate: term.termEnd,
        userID: profile.userID,
        bookingStatus: BookingStatus.all,
      ),
    );
  }

  return await reservationClient.search(
    data: ReservationSearchRequest(
      branchName: user.branchName,
      startDate: term.termStart,
      endDate: term.termEnd,
      userID: user.userID,
      bookingStatus: BookingStatus.all,
    ),
  );
}
