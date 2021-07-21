import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource(List<dynamic> reservations) {
    List<dynamic> bookedReservations = [];
    for (int i = 0; i < reservations.length; i++) {
      if (reservations[i].getBookingStatus() != 2 &&
          reservations[i].getBookingStatus() != -2) {
        bookedReservations.add(reservations[i]);
      }
    }
    appointments = bookedReservations;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].getStartDate();
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index]
        .getEndDate()
        .add(Duration(minutes: appointments![index].extendedMin));
  }

  @override
  String getSubject(int index) {
    return appointments![index].getSubject();
  }

  @override
  Color getColor(int index) {
    return appointments![index].getBackgroundColor();
  }
}

class MyTimeslotReservation {
  Reservation reservation;
  String subject;
  Color backgroundColor;

  MyTimeslotReservation(
    this.reservation, [
    this.subject = "내 예약",
    this.backgroundColor = const Color(0xFF0F8644),
  ]);

  DateTime getStartDate() => reservation.startDate;
  DateTime getEndDate() => reservation.endDate;
  String getSubject() => subject;
  Color getBackgroundColor() => backgroundColor;
  int getBookingStatus() => reservation.bookingStatus;
}

class TeacherOnlyTimeslotReservation {
  Reservation reservation;
  String subject;
  Color backgroundColor;

  TeacherOnlyTimeslotReservation(
    this.reservation, [
    this.subject = "선생님 스케줄",
    this.backgroundColor = const Color(0xFF0F8644),
  ]);

  DateTime getStartDate() => reservation.startDate;
  DateTime getEndDate() => reservation.endDate;
  String getSubject() => subject;
  Color getBackgroundColor() => backgroundColor;
  int getBookingStatus() => reservation.bookingStatus;
}

List<dynamic> getDataSource() {
  MyReservationController _myReservationController =
      Get.put(MyReservationController());
  TeacherReservationController _teacherReservationController =
      Get.put(TeacherReservationController());

  List<Reservation> _teacherOnlyReservations = _teacherReservationController
      .reservations
      .toSet()
      .difference(_myReservationController.reservations.toSet())
      .toList();
  List<dynamic> _myTimeslotReservations = [];
  for (int i = 0; i < _myReservationController.reservations.length; i++) {
    _myTimeslotReservations
        .add(MyTimeslotReservation(_myReservationController.reservations[i]));
  }
  List<dynamic> _teacherOnlyTimeslotReservations = [];
  for (int i = 0; i < _teacherOnlyReservations.length; i++) {
    _teacherOnlyTimeslotReservations
        .add(TeacherOnlyTimeslotReservation(_teacherOnlyReservations[i]));
  }
  _myTimeslotReservations.addAll(_teacherOnlyTimeslotReservations);
  return _myTimeslotReservations;
}

List<TimeRegion> getTimeRegions() {
  TeacherController _teacherController = Get.put(TeacherController());
  List<TimeRegion> regions = [];
  final DateTime today = DateTime.now();
  regions.add(TimeRegion(
    startTime: DateTime(today.year, today.month, today.day, 0),
    endTime: _teacherController.teacher.startTime,
    recurrenceRule: "FREQ=DAILY;INTERVAL=1",
    enablePointerInteraction: false,
    color: Colors.red.withOpacity(0.5),
    text: "수업 시간 외",
  ));
  regions.add(TimeRegion(
    startTime: _teacherController.teacher.endTime,
    endTime: DateTime(today.year, today.month, today.day, 24),
    recurrenceRule: "FREQ=DAILY;INTERVAL=1",
    enablePointerInteraction: false,
    color: Colors.red.withOpacity(0.5),
    text: "수업 시간 외",
  ));
  return regions;
}
