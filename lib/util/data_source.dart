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

Future<void> getUserBaseData() async {
  Client client = Get.put(Client());
  DataController _controller = Get.find<DataController>();

  await _controller.updateUser(await client.getProfile());

  await _controller.updateRegularSchedules(await client.getRegularSchedules()
    ..sort((a, b) => a.startTime.compareTo(b.startTime)));

  await _controller.updateTeachers(await client.getTeachers(
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
  await _controller.updateMyValidReservations(_myValidReservations);

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
  await _controller
      .updateTeacherOnlyValidReservations(_teacherOnlyValidReservations);

  await _controller.updateMyThisMonthReservations(await client.getReservations(
    branchName: "잠실",
    startDate: DateTime(kToday.year, kToday.month, 1),
    endDate: DateTime(kToday.year, kToday.month + 1, 0, 23, 59, 59),
    userID: "sleep",
    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
  )
    ..sort((a, b) => a.startDate.compareTo(b.startDate)));

  await _controller.updateMyLastMonthReservations(await client.getReservations(
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
  await _controller.updateOpenControls(_openControls);
  await _controller.updateCloseControls(_closeControls);
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
  List<Reservation> _teacherOnlyValidReservations =
      _controller.teacherOnlyValidReservations;
  List<Teacher> _teachers = _controller.teachers;
  List<Control> _closeControls = _controller.closeControls;

  List<TimeRegion> regions = []
    ..addAll(List<TimeRegion>.generate(
      _teacherOnlyValidReservations.length,
      (index) => TimeRegion(
        startTime: _teacherOnlyValidReservations[index].startDate,
        endTime: _teacherOnlyValidReservations[index].endDate.add(Duration(
            minutes: _teacherOnlyValidReservations[index].extendedMin)),
        text: "선생님 스케줄",
        color: Colors.red.withOpacity(0.5),
        enablePointerInteraction: false,
        textStyle: TextStyle(),
      ),
    ))
    ..addAll(List<TimeRegion>.generate(
      _teachers.length,
      (index) {
        DateTime _startTime = kFirstDay
            .add(Duration(days: getFirstWeekday(_teachers[index].workDow)));

        return TimeRegion(
          startTime: _startTime.add(_teachers[index].endTime),
          endTime: _startTime.add(Duration(days: 1)),
          text: "수업 시간 외",
          recurrenceRule:
              "FREQ=WEEKLY;INTERVAL=1;BYDAY=${dowToRRuleString(_teachers[index].workDow)}",
          color: Colors.black.withOpacity(0.5),
          enablePointerInteraction: false,
          textStyle: TextStyle(),
        );
      },
    ))
    ..addAll(List<TimeRegion>.generate(
      _teachers.length,
      (index) {
        DateTime _startTime = kFirstDay
            .add(Duration(days: getFirstWeekday(_teachers[index].workDow)));

        return TimeRegion(
          startTime: _startTime,
          endTime: _startTime.add(_teachers[index].startTime),
          text: "수업 시간 외",
          recurrenceRule:
              "FREQ=WEEKLY;INTERVAL=1;BYDAY=${dowToRRuleString(_teachers[index].workDow)}",
          color: Colors.black.withOpacity(0.5),
          enablePointerInteraction: false,
          textStyle: TextStyle(),
        );
      },
    ))
    ..addAll(List<TimeRegion>.generate(
      _closeControls.length,
      (index) => TimeRegion(
        startTime: _closeControls[index].controlStart,
        endTime: _closeControls[index].controlEnd,
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
