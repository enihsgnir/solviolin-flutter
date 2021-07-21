import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyCalendarDataSource extends CalendarDataSourceChangeNotifier {
  List<dynamic>? reservations;

  // List<Appointment> getVisibleAppointments(
  //     DateTime startDate, String calendarTimeZone,
  //     [DateTime? endDate]) {
  //   endDate ??= startDate;

  //   List<CalendarAppointment> calendarAppointments =
  //       AppointmentHelper.generateCalendarAppointments(this, calendarTimeZone);

  //   calendarAppointments = AppointmentHelper.getVisibleAppointments(
  //       startDate, endDate, calendarAppointments, calendarTimeZone, false,
  //       canCreateNewAppointment: false);

  //   final List<Appointment> visibleAppointments = <Appointment>[];

  //   for (int i = 0; i < calendarAppointments.length; i++) {
  //     visibleAppointments
  //         .add(calendarAppointments[i].convertToCalendarAppointment());
  //   }

  //   return visibleAppointments;
  // }

  List<CalendarResource>? resources;

  DateTime getStartTime(int index) => DateTime.now();
  DateTime getEndTime(int index) => DateTime.now();
  String getSubject(int index) => '';
  bool isAllDay(int index) => false;
  Color getColor(int index) => Colors.lightBlue;
  String? getNotes(int index) => null;
  String? getLocation(int index) => null;
  String? getStartTimeZone(int index) => null;
  String? getEndTimeZone(int index) => null;
  String? getRecurrenceRule(int index) => null;
  List<DateTime>? getRecurrenceExceptionDates(int index) => null;
  List<Object>? getResourceIds(int index) => null;
}
