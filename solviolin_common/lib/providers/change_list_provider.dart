import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/change.dart';
import 'package:solviolin_common/providers/client_state/reservation_state_provider.dart';

part 'change_list_provider.g.dart';

@riverpod
Future<List<Change>> changeList(Ref ref, String? userID) async {
  final reservationClient = ref.watch(reservationStateProvider);
  const range = "both";

  if (userID == null) {
    return await reservationClient.getChanges(range: range);
  }
  return await reservationClient.getChangesByUserID(userID, range: range);
}
