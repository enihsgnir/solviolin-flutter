import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/booking_status.dart';
import 'package:solviolin_common/models/teacher_color.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

@freezed
class Reservation with _$Reservation {
  const factory Reservation({
    required int id,
    required DateTime startDate,
    required DateTime endDate,
    required BookingStatus bookingStatus,
    required String userID,
    required String teacherID,
    required String branchName,
    int? regularID,
    required TeacherColor teacher,
  }) = _Reservation;

  const Reservation._();

  (DateTime, DateTime) get range => (startDate, endDate);

  Color? get color => teacher.color;

  // for compatibility with sf_calendar
  String get notes => "";

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
