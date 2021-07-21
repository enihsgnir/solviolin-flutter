import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_table_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarReserved extends StatefulWidget {
  final StreamController<DateTime> streamController;

  const CalendarReserved({
    Key? key,
    required this.streamController,
  }) : super(key: key);

  @override
  _CalendarReservedState createState() => _CalendarReservedState();
}

class _CalendarReservedState extends State<CalendarReserved> {
  DateTime _focusedDay = kToday;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MyReservationController());
    return GetBuilder<MyReservationController>(
      builder: (controller) {
        return TableCalendar(
          focusedDay: _focusedDay,
          firstDay: kFirstDay,
          lastDay: kLastDay,
          locale: "ko-KR",
          weekendDays: const [DateTime.sunday],
          availableCalendarFormats: const {CalendarFormat.month: "Month"},
          pageJumpingEnabled: true,
          sixWeekMonthsEnforced: true,
          // shouldFillViewport: true,
          daysOfWeekHeight: 20,
          headerStyle: HeaderStyle(
            titleCentered: true,
            // titleTextFormatter: (date, locale) =>
            //     DateFormat.yMMMMd(locale).format(date),
          ),
          calendarStyle: CalendarStyle(
            canMarkersOverflow: false,
            markerSizeScale: 1,
            markersAlignment: Alignment.center,
            markerDecoration: const BoxDecoration(
              color: const Color(0xFF263238),
              shape: BoxShape.rectangle,
            ),
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
          ),
          eventLoader: (day) => getEvents()[day] ?? [],
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.streamController.add(_selectedDay);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        );
      },
    );
  }
}
