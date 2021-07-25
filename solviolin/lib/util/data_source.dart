import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/notification.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

Future<void> getUserBaseData(BuildContext context) async {
  Client client = Get.put(Client());
  DataController _controller = Get.find<DataController>();

  _controller.updateUser(await client.getProfile());

  _controller.updateRegularSchedules(await client.getRegularSchedules());

  _controller.updateTeachers(await client.getTeachers(
    teacherID: _controller.regularSchedules[0].teacherID,
    branchName: _controller.user.branchName,
  ));

  List<Reservation> _myReservations =
      await client.getReservations("잠실", userID: "sleep");
  _controller.updateMyReservations(_myReservations);

  List<Reservation> _teacherReservations = await client.getReservations("잠실",
      teacherID: _controller.teachers[0].teacherID);
  _controller.updateTeacherReservations(_teacherReservations);

  List<Reservation> _myValidReservations = [];
  for (int i = 0; i < _myReservations.length; i++) {
    if (_myReservations[i].bookingStatus != 2 &&
        _myReservations[i].bookingStatus != -2) {
      _myValidReservations.add(_myReservations[i]);
    }
  }
  _controller.updateMyValidReservations(_myValidReservations);

  List<Reservation> _teacherValidReservations = [];
  for (int i = 0; i < _teacherReservations.length; i++) {
    if (_teacherReservations[i].bookingStatus != 2 &&
        _teacherReservations[i].bookingStatus != -2) {
      _teacherValidReservations.add(_teacherReservations[i]);
    }
  }
  List<Reservation> _teacherOnlyValidReservations = _teacherValidReservations
      .toSet()
      .difference(_myValidReservations.toSet())
      .toList();
  _controller.updateTeacherOnlyValidReservations(_teacherOnlyValidReservations);

  if (!await _controller.checkAllComplete()) {
    showErrorMessage(context);
  }
}

//SfCalendar DataSource
//
class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource(List<Reservation> reservations) {
    appointments = reservations;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startDate;

  @override
  DateTime getEndTime(int index) => appointments![index]
      .endDate
      .add(Duration(minutes: appointments![index].extendedMin));

  @override
  String getSubject(int index) => "내 예약";

  @override
  Color getColor(int index) => const Color(0xFF0F8644);
}

List<TimeRegion> getTimeRegions() {
  DataController _controller = Get.find<DataController>();
  List<TimeRegion> regions = [];
  final DateTime today = DateTime.now();
  regions.add(TimeRegion(
    startTime: DateTime(today.year, today.month, today.day, 0),
    endTime: DateTime(today.year, today.month, today.day, 0)
        .add(_controller.teachers[0].startTime),
    recurrenceRule: "FREQ=DAILY;INTERVAL=1",
    enablePointerInteraction: false,
    color: Colors.red.withOpacity(0.5),
    text: "수업 시간 외",
  ));
  regions.add(TimeRegion(
    startTime: DateTime(today.year, today.month, today.day, 0)
        .add(_controller.teachers[0].endTime),
    endTime: DateTime(today.year, today.month, today.day, 24),
    recurrenceRule: "FREQ=DAILY;INTERVAL=1",
    enablePointerInteraction: false,
    color: Colors.red.withOpacity(0.5),
    text: "수업 시간 외",
  ));
  regions.add(TimeRegion(
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    color: const Color(0xFF0F8644),
    text: "선생님 스케줄",
  ));
  return regions;
}

//TableCalendar DataSource
//
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 6, 1);
final kLastDay = DateTime(kToday.year, kToday.month + 7, 0);

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

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

//HourlyReserved DataSource
//
List<FlutterWeekViewEvent> getWeekViewEvents() {
  List<Reservation> _myValidReservations =
      Get.find<DataController>().myValidReservations;
  List<FlutterWeekViewEvent>.generate(
    _myValidReservations.length,
    (index) => FlutterWeekViewEvent(
      title: "내 예약",
      description: "description",
      start: _myValidReservations[index].startDate,
      end: _myValidReservations[index]
          .endDate
          .add(Duration(minutes: _myValidReservations[index].extendedMin)),
      backgroundColor: const Color(0xFF0F8644),
      onTap: () {},
    ),
  );

  List<Reservation> _teacherOnlyValidReservations =
      Get.find<DataController>().teacherOnlyValidReservations;
  List<FlutterWeekViewEvent>.generate(
    _teacherOnlyValidReservations.length,
    (index) => FlutterWeekViewEvent(
      title: "선생님 스케줄",
      description: "description",
      start: _teacherOnlyValidReservations[index].startDate,
      end: _teacherOnlyValidReservations[index].endDate.add(
          Duration(minutes: _teacherOnlyValidReservations[index].extendedMin)),
      backgroundColor: Colors.red,
    ),
  );

  return [];
}
