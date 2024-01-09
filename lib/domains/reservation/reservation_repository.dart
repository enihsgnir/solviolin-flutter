import 'package:solviolin/domains/reservation/change.dart';
import 'package:solviolin/domains/reservation/reservation_client.dart';
import 'package:solviolin/utils/client.dart';

final _client = ReservationClient(dio);

Future<List<Change>> getChanges() async {
  return await _client.getChanges(range: "both");
}

Future<void> cancelReservationByAdmin(
  int id, {
  required bool deductCredit,
}) async {
  await _client.cancelReservationByAdmin(id, deductCredit ? 1 : 0);
}

Future<void> extendReservationByAdmin(
  int id, {
  required bool deductCredit,
}) async {
  await _client.extendReservationByAdmin(id, deductCredit ? 1 : 0);
}

Future<List<Change>> getChangesWithID(String userID) async {
  return await _client.getChangesWithID(userID, range: "both");
}

Future<void> deleteReservation(int id) async {
  await _client.deleteReservation(ids: [id]);
}
