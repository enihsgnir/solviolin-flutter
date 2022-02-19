import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

bool isSameWeek(DateTime newDate, DateTime oldDate) {
  final weekday = oldDate.weekday % 7;
  final first = DateTime(oldDate.year, oldDate.month, oldDate.day - weekday);
  final last =
      first.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

  return DateUtils.isSameDay(newDate, first) ||
      DateUtils.isSameDay(newDate, last) ||
      (newDate.isAfter(first) && newDate.isBefore(last));
}

class ReservationDataSource extends CalendarDataSource {
  var _data = Get.find<DataController>();

  ReservationDataSource() {
    appointments = _data.reservations;

    resources = List.generate(
      _data.teacherInfos.length,
      (index) => CalendarResource(
        displayName: _data.teacherInfos[index].teacherID,
        id: index,
        color: _data.teacherInfos[index].color ?? Colors.transparent,
      ),
    )..add(CalendarResource(
        displayName: "Others",
        id: -1,
        color: Colors.transparent,
      ));
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startDate;

  @override
  DateTime getEndTime(int index) => appointments![index].endDate;

  @override
  String getSubject(int index) =>
      appointments![index].userID +
      "\n" +
      formatTimeRange(getStartTime(index), getEndTime(index));

  @override
  Color getColor(int index) => appointments![index].color;

  @override
  List<Object> getResourceIds(int index) {
    var teacherIds = _data.teacherInfos.map((e) => e.teacherID).toList();

    return [teacherIds.indexOf(appointments![index].teacherID)];
  }
}
