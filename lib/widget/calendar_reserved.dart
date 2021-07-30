import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
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
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    Get.find<DataController>();

    return GetBuilder<DataController>(
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
          rowHeight: deviceHeight * 0.065,
          daysOfWeekHeight: deviceHeight * 0.02,
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              size: deviceHeight * 0.0225,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              size: deviceHeight * 0.0225,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: const Color(0xFF4F4F4F),
              fontSize: 48,
              fontWeight: FontWeight.w800,
            ),
            weekendStyle: TextStyle(
              color: Colors.red,
              fontSize: 48,
              fontWeight: FontWeight.w800,
            ),
          ),
          calendarStyle: CalendarStyle(
            canMarkersOverflow: false,
            markerSizeScale: 1.5,
            markersAlignment: Alignment.center,
            markerDecoration: const BoxDecoration(
              color: const Color(0xFF263238),
              shape: BoxShape.rectangle,
            ),
            todayTextStyle: TextStyle(
              color: const Color(0xFFFAFAFA),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
            selectedTextStyle: TextStyle(
              color: const Color(0xFFFAFAFA),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
            outsideTextStyle: TextStyle(
              color: const Color(0xFFAEAEAE),
              fontSize: 48,
            ),
            disabledTextStyle: TextStyle(
              color: const Color(0xFFBFBFBF),
              fontSize: 48,
            ),
            holidayTextStyle: TextStyle(
              color: const Color(0xFF5C6BC0),
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
            holidayDecoration: BoxDecoration(
              border: const Border.fromBorderSide(
                const BorderSide(color: const Color(0xFF9FA8DA), width: 1.4),
              ),
            ),
            weekendTextStyle: TextStyle(
              color: Colors.red,
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
            defaultTextStyle: TextStyle(
              color: Colors.white70,
              fontSize: 48,
              fontWeight: FontWeight.w700,
            ),
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          holidayPredicate: (day) => getEvents().containsKey(day),
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
