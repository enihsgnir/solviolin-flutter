import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/dto/available_spot_search_request.dart';
import 'package:solviolin/models/regular_schedule.dart';
import 'package:solviolin/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin/providers/selected_day_provider.dart';

part 'available_spots_provider.g.dart';

@riverpod
Future<List<DateTime>> availableSpots(
  Ref ref,
  RegularSchedule regularSchedule,
) async {
  final selectedDay = ref.watch(selectedDayProvider);

  final reservationClient = ref.watch(reservationStateProvider);
  final availableSpots = await reservationClient.getAvailableSpots(
    data: AvailableSpotSearchRequest(
      branchName: regularSchedule.branchName,
      teacherID: regularSchedule.teacherID,
      startDate: selectedDay,
    ),
  );

  final validSpots = availableSpots
      .map(DateTime.parse)

      // if the spot is after 4 hours from now
      .where((e) {
    final bufferTime = DateTime.now().add(const Duration(hours: 4));
    return e.isAfter(bufferTime);
  })

      // if the spot is valid for the regular schedule
      .where((e) {
    if (regularSchedule.isWeekend) {
      return true;
    } else if (regularSchedule.isDaytime) {
      return e.hour < 16;
    }
    return true;
  });

  return validSpots.toList();
}
