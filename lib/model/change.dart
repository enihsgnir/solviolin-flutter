import 'package:solviolin_admin/model/reservation.dart';

class Change {
  int id;
  int fromID;
  int toID;
  int isPostponed;
  int used;
  Reservation from;
  Reservation? to;

  Change({
    required this.id,
    required this.fromID,
    required this.toID,
    required this.isPostponed,
    required this.used,
    required this.from,
    this.to,
  });

  factory Change.fromJson(Map<String, dynamic> json) {
    return Change(
      id: json["id"],
      fromID: json["fromID"],
      toID: json["toID"],
      isPostponed: json["isPostponed"],
      used: json["used"],
      from: Reservation.fromJson(json["from"]),
      to: Reservation.fromJson(json["to"]),
    );
  }
}
