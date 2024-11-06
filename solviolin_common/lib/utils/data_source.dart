import 'package:flutter/material.dart';
import 'package:solviolin_common/models/reservation.dart';
import 'package:solviolin_common/models/teacher_info.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservationDataSource extends CalendarDataSource {
  final List<Reservation> reservations;
  final List<TeacherInfo> teacherInfos;

  ReservationDataSource({
    required this.reservations,
    required this.teacherInfos,
  }) {
    appointments = reservations;

    resources = [
      for (final info in teacherInfos)
        CalendarResource(
          id: info.teacherID,
          displayName: info.teacherID,
          color: info.color,
        ),
      CalendarResource(id: "", displayName: "기타", color: Colors.white),
    ];
  }

  @override
  DateTime getStartTime(int index) => reservations[index].startDate;

  @override
  DateTime getEndTime(int index) => reservations[index].endDate;

  @override
  String getSubject(int index) => reservations[index].userID;

  @override
  Color getColor(int index) => reservations[index].color ?? Colors.white;

  @override
  List<Object> getResourceIds(int index) => [reservations[index].teacherID];
}
