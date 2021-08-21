import 'package:solviolin/model/reservation.dart';

class Change {
  Reservation from;
  Reservation? to;

  Change({
    required this.from,
    this.to,
  });

  factory Change.fromJson(Map<String, dynamic> json) {
    return Change(
      from: Reservation.fromJson(json["from"]),
      to: Reservation.fromJson(json["to"]),
    );
  }
}
