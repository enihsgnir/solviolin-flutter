import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/control.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/model/teacher.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 6, 1);
final kLastDay = DateTime(kToday.year, kToday.month + 7, 0);

Future<void> getUserBasedData() async {
  Client client = Get.put(Client());
  DataController _controller = Get.find<DataController>();

  _controller.updateUser(await client.getProfile());

  _controller.updateRegularSchedules(await client.getRegularSchedules()
    ..sort((a, b) => a.startTime.compareTo(b.startTime)));

  _controller.updateTeachers(await client.getTeachers(
    teacherID: _controller.regularSchedules[0].teacherID,
    branchName: _controller.user.branchName,
  )
    ..sort((a, b) => a.workDow.compareTo(b.workDow)));

  List<Reservation> _myValidReservations = await client.getReservations(
    branchName: "잠실",
    startDate: kFirstDay,
    endDate: kLastDay.add(Duration(hours: 23, minutes: 59, seconds: 59)),
    userID: "sleep",
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate));
  _controller.updateMyValidReservations(_myValidReservations);

  List<Reservation> _teacherValidReservations = await client.getReservations(
    branchName: "잠실",
    teacherID: _controller.teachers[0].teacherID,
    startDate: kFirstDay,
    endDate: kLastDay.add(Duration(hours: 23, minutes: 59, seconds: 59)),
    bookingStatus: [-3, -1, 0, 1, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate));
  List<Reservation> _teacherOnlyValidReservations = _teacherValidReservations
      .toSet()
      .difference(_myValidReservations.toSet())
      .toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
  _controller.updateTeacherOnlyValidReservations(_teacherOnlyValidReservations);

  _controller.updateMyThisMonthReservations(await client.getReservations(
    branchName: "잠실",
    startDate: DateTime(kToday.year, kToday.month, 1),
    endDate: DateTime(kToday.year, kToday.month + 1, 0, 23, 59, 59),
    userID: "sleep",
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  _controller.updateMyLastMonthReservations(await client.getReservations(
    branchName: "잠실",
    startDate: DateTime(kToday.year, kToday.month - 1, 1),
    endDate: DateTime(kToday.year, kToday.month, 0, 23, 59, 59),
    userID: "sleep",
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  List<Control> _controls = await client.getControls(
    teacherID: _controller.teachers[0].teacherID,
    branchName: "잠실",
  )
    ..sort((a, b) => a.controlStart.compareTo(b.controlStart));
  List<Control> _openControls = [];
  List<Control> _closeControls = [];
  for (int i = 0; i < _controls.length; i++) {
    if (_controls[i].status == 0) {
      _openControls.add(_controls[i]);
    } else {
      _closeControls.add(_controls[i]);
    }
  }
  _controller.updateOpenControls(_openControls);
  _controller.updateCloseControls(_closeControls);
}

//CalendarReserved DataSource
//
extension _Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

LinkedHashMap<DateTime, List<Reservation>> getEvents() =>
    LinkedHashMap<DateTime, List<Reservation>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(getEventSource());

Map<DateTime, List<Reservation>> getEventSource() =>
    Get.find<DataController>().myValidReservations.groupBy((reservation) {
      DateTime date = reservation.startDate;
      return DateTime(date.year, date.month, date.day);
    });

int getHashCode(DateTime key) =>
    key.day * 1000000 + key.month * 10000 + key.year;

//TimeslotReserved DataSource
//
class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource(List<Reservation> reservations) {
    DataController _controller = Get.find<DataController>();

    appointments = reservations
      ..addAll(List<Reservation>.generate(
        _controller.openControls.length,
        (index) => Reservation(
          id: 0,
          startDate: _controller.openControls[index].controlStart,
          endDate: _controller.openControls[index].controlEnd,
          bookingStatus: 127,
          extendedMin: 0,
          userID: _controller.user.userID,
          teacherID: _controller.teachers[0].teacherID,
          branchName: _controller.regularSchedules[0].branchName,
        ),
      ));
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startDate;

  @override
  DateTime getEndTime(int index) => appointments![index]
      .endDate
      .add(Duration(minutes: appointments![index].extendedMin));

  @override
  String getSubject(int index) => appointments![index].bookingStatus == 127
      ? "추가 수업 시간\n터치 시 예약 가능"
      : "내 예약";

  @override
  Color getColor(int index) => appointments![index].bookingStatus == 127
      ? Colors.amber.withOpacity(0.5)
      : const Color(0xFF0F8644).withOpacity(0.5);
}

List<TimeRegion> getTimeRegions() {
  DataController _controller = Get.find<DataController>();
  List<Reservation> teacherOnlyValidReservations =
      _controller.teacherOnlyValidReservations;
  List<Teacher> teachers = _controller.teachers;
  List<Control> closeControls = _controller.closeControls;

  List<TimeRegion> regions = []
    ..addAll(List<TimeRegion>.generate(
      teacherOnlyValidReservations.length,
      (index) => TimeRegion(
        startTime: teacherOnlyValidReservations[index].startDate,
        endTime: teacherOnlyValidReservations[index].endDate.add(
            Duration(minutes: teacherOnlyValidReservations[index].extendedMin)),
        text: "선생님 스케줄",
        color: Colors.red.withOpacity(0.5),
        enablePointerInteraction: false,
        textStyle: TextStyle(),
      ),
    ))
    ..addAll(List<TimeRegion>.generate(
      teachers.length,
      (index) {
        DateTime startTime = kFirstDay
            .add(Duration(days: getFirstWeekday(teachers[index].workDow)));

        return TimeRegion(
          startTime: startTime.add(teachers[index].endTime),
          endTime: startTime.add(Duration(days: 1)),
          text: "수업 시간 외",
          recurrenceRule:
              "FREQ=WEEKLY;INTERVAL=1;BYDAY=${dowToRRuleString(teachers[index].workDow)}",
          color: Colors.black.withOpacity(0.5),
          enablePointerInteraction: false,
          textStyle: TextStyle(),
        );
      },
    ))
    ..addAll(List<TimeRegion>.generate(
      teachers.length,
      (index) {
        DateTime startTime = kFirstDay
            .add(Duration(days: getFirstWeekday(teachers[index].workDow)));

        return TimeRegion(
          startTime: startTime,
          endTime: startTime.add(teachers[index].startTime),
          text: "수업 시간 외",
          recurrenceRule:
              "FREQ=WEEKLY;INTERVAL=1;BYDAY=${dowToRRuleString(teachers[index].workDow)}",
          color: Colors.black.withOpacity(0.5),
          enablePointerInteraction: false,
          textStyle: TextStyle(),
        );
      },
    ))
    ..addAll(List<TimeRegion>.generate(
      closeControls.length,
      (index) => TimeRegion(
        startTime: closeControls[index].controlStart,
        endTime: closeControls[index].controlEnd,
        text: "예약 불가",
        color: Colors.brown.withOpacity(0.5),
        enablePointerInteraction: false,
        textStyle: TextStyle(),
      ),
    ));

  return regions;
}

int getFirstWeekday(int workDow) {
  int weekday = kFirstDay.weekday;
  if (weekday == 7) {
    weekday = 0;
  }

  return weekday <= workDow ? workDow - weekday : 7 - (workDow - weekday);
}
