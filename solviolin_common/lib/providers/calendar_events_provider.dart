import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';
import 'package:solviolin_common/providers/my_valid_reservations_provider.dart';

part 'calendar_events_provider.g.dart';

@riverpod
Future<Set<DateTime>> calendarEvents(Ref ref) async {
  final reservations = await ref.watch(myValidReservationsProvider.future);
  return reservations.map((e) => e.startDate.dateOnly).toSet();
}
