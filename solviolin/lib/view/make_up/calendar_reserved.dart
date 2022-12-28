import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/widget/dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarReserved extends StatefulWidget {
  const CalendarReserved({Key? key}) : super(key: key);

  @override
  _CalendarReservedState createState() => _CalendarReservedState();
}

class _CalendarReservedState extends State<CalendarReserved> {
  var today = DateTime.now();
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  var events = getEvents();

  @override
  void initState() {
    super.initState();
    _selectedDay = today;
    _focusedDay = today;
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(today.year, today.month - 5, 1),
          lastDay: controller.currentTerm[0].termEnd, // normalized date
          currentDay: today,
          locale: "en_US", // not timezone
          weekendDays: const [DateTime.sunday],
          availableCalendarFormats: const {CalendarFormat.month: "Month"},
          pageJumpingEnabled: true,
          sixWeekMonthsEnforced: true,
          rowHeight: 60.r,
          daysOfWeekHeight: 20.r,
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextFormatter: (date, locale) =>
                DateFormat.yMMM(locale).format(date),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 28.r,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, size: 28.r),
            rightChevronIcon: Icon(Icons.chevron_right, size: 28.r),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0],
            weekdayStyle: TextStyle(
              color: Colors.white54,
              fontSize: 18.r,
            ),
            weekendStyle: TextStyle(color: Colors.red, fontSize: 20.r),
          ),
          calendarStyle: CalendarStyle(
            todayTextStyle: TextStyle(
              color: Colors.black87,
              fontSize: 22.r,
              fontWeight: FontWeight.bold,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.green.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: _getSelectedTextColor(),
              fontSize: 22.r,
              fontWeight: isSameDay(_selectedDay, today)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            selectedDecoration: BoxDecoration(
              color: _getSelectedDecorationColor(),
              shape: BoxShape.circle,
            ),
            outsideTextStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5),
              fontSize: 18.r,
            ),
            disabledTextStyle: TextStyle(
              color: Colors.grey.withOpacity(0.1),
              fontSize: 18.r,
            ),
            holidayTextStyle: TextStyle(color: Colors.white70, fontSize: 22.r),
            holidayDecoration: BoxDecoration(
              color: symbolColor,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(color: Colors.red, fontSize: 22.r),
            defaultTextStyle: TextStyle(color: Colors.white70, fontSize: 22.r),
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          holidayPredicate: (day) => events.containsKey(day),
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                today = DateTime.now();
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              controller.update();
            }

            if (selectedDay.isAfter(today) || isSameDay(selectedDay, today)) {
              showLoading(() async {
                try {
                  await controller.getSelectedDayData(selectedDay);

                  setState(() {
                    events = getEvents();
                  });
                } catch (e) {
                  showError(e);
                }
              });
            }

            controller.setDays(selectedDay, focusedDay);
          },
          onPageChanged: (focusedDay) {
            today = DateTime.now();
            _selectedDay = focusedDay;
            _focusedDay = focusedDay;
            controller.update();

            showLoading(() async {
              try {
                await controller.getSelectedDayData(focusedDay);
                await controller.getChangedPageData(focusedDay);

                setState(() {
                  events = getEvents();
                });
              } catch (e) {
                showError(e);
              }
            });

            controller.setDays(focusedDay, focusedDay);
          },
        );
      },
    );
  }

  Color _getSelectedTextColor() {
    if (isSameDay(_selectedDay, today)) {
      return Colors.black87;
    } else if (events.containsKey(_selectedDay)) {
      return Colors.white70;
    } else if (_selectedDay.weekday == 7) {
      return Colors.red[400]!;
    }
    return const Color(0xFFFAFAFA);
  }

  Color _getSelectedDecorationColor() {
    if (isSameDay(_selectedDay, today)) {
      return Colors.green[300]!.withOpacity(0.5);
    } else if (events.containsKey(_selectedDay)) {
      return symbolColor.withOpacity(0.25);
    }
    return const Color.fromRGBO(227, 214, 208, 0.15);
  }
}

extension _Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (map, element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

Map<DateTime, List<Reservation>> getEventSource() {
  var _data = Get.find<DataController>();

  return _data.myValidReservations.groupBy((reservation) {
    var date = reservation.startDate;

    return DateTime(date.year, date.month, date.day);
  });
}

LinkedHashMap<DateTime, List<Reservation>> getEvents() => LinkedHashMap(
      equals: isSameDay,
      hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
    )..addAll(getEventSource());
