import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/booking_status.dart';
import 'package:solviolin_common/models/dto/reservation_search_request.dart';
import 'package:solviolin_common/models/reservation.dart';
import 'package:solviolin_common/providers/canceled_provider.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin_common/providers/term_range_provider.dart';

part 'canceled_made_up_map_provider.g.dart';

@riverpod
Future<Map<int, Reservation?>> canceledMadeUpMap(
  Ref ref,
  int canceledID,
) async {
  final canceled = await ref.watch(canceledProvider(canceledID).future);

  final toIDs = canceled.toIDs;
  if (toIDs.isEmpty) {
    return {};
  }

  final termRange = await ref.watch(termRangeProvider.future);

  final reservationClient = ref.watch(reservationStateProvider);
  final reservationList = await reservationClient.search(
    data: ReservationSearchRequest(
      branchName: canceled.branchName,
      teacherID: canceled.teacherID,
      userID: canceled.userID,
      startDate: termRange.previous.termStart,
      endDate: termRange.next.termEnd,
      bookingStatus: BookingStatus.all,
    ),
  );

  final reservationMap = {for (final e in reservationList) e.id: e};
  return {for (final toID in toIDs) toID: reservationMap[toID]};
}
