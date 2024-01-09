import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/teacher/teacher_info.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

enum BookingStatus {
  @JsonValue(0)
  regular,

  @JsonValue(1)
  madeUp,

  @JsonValue(2)
  canceled,

  @JsonValue(3)
  extended,

  @JsonValue(-1)
  madeUpByAdmin,

  @JsonValue(-2)
  cancelledByAdmin,

  @JsonValue(-3)
  extendedByAdmin,
}

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
    TeacherColor? teacher,
  }) = _Reservation;

  const Reservation._();

  Color? get color => teacher?.color;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
