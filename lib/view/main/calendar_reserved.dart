import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarReserved extends StatefulWidget {
  const CalendarReserved({Key? key}) : super(key: key);

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
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(kToday.year, kToday.month - 5, 1),
          lastDay: controller.currentTerm[0].termEnd
              .add(const Duration(hours: 23, minutes: 59, seconds: 59)),
          currentDay: DateTime.now().add(const Duration(hours: 9)),
          weekendDays: const [DateTime.sunday],
          availableCalendarFormats: const {CalendarFormat.month: "Month"},
          pageJumpingEnabled: true,
          sixWeekMonthsEnforced: true,
          rowHeight: 72.r,
          daysOfWeekHeight: 24.r,
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextFormatter: (date, locale) =>
                DateFormat.yMMM().format(date),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 32.r,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, size: 32.r),
            rightChevronIcon: Icon(Icons.chevron_right, size: 32.r),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0],
            weekdayStyle: TextStyle(
              color: const Color(0xFF4F4F4F),
              fontSize: 20.r,
            ),
            weekendStyle: TextStyle(color: Colors.red, fontSize: 20.r),
          ),
          calendarStyle: CalendarStyle(
            todayTextStyle: TextStyle(
              color: kToday.weekday == 7 ? const Color(0xFFFAFAFA) : Colors.red,
              fontSize: 24.r,
            ),
            todayDecoration: BoxDecoration(
              color: kToday.weekday == 7 ? Colors.red : const Color(0xFFFAFAFA),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: _selectedDay.weekday == 7
                  ? Colors.red
                  : const Color(0xFFFAFAFA),
              fontSize: 24.r,
            ),
            selectedDecoration: const BoxDecoration(
              color: const Color.fromRGBO(227, 214, 208, 0.15),
              shape: BoxShape.circle,
            ),
            outsideTextStyle: TextStyle(
              color: Colors.grey.withOpacity(0.5),
              fontSize: 20.r,
            ),
            disabledTextStyle: TextStyle(
              color: Colors.grey.withOpacity(0.1),
              fontSize: 20.r,
            ),
            holidayTextStyle: TextStyle(color: Colors.white, fontSize: 24.r),
            holidayDecoration: BoxDecoration(
              color: symbolColor,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(color: Colors.red, fontSize: 24.r),
            defaultTextStyle: TextStyle(color: Colors.white70, fontSize: 24.r),
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          holidayPredicate: (day) => getEvents().containsKey(day),
          onDaySelected: (selectedDay, focusedDay) async {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }

            if (selectedDay.isAfter(kToday) || isSameDay(selectedDay, kToday)) {
              await getSelectedDayData(selectedDay);
            }

            controller.updateDays(selectedDay, focusedDay);
            controller.resetCurrentPage();
          },
          onPageChanged: (focusedDay) async {
            _selectedDay = focusedDay;
            _focusedDay = focusedDay;

            await getSelectedDayData(focusedDay);
            await getChangedPageData(focusedDay);

            controller.updateDays(focusedDay, focusedDay);
            controller.resetCurrentPage();
          },
        );
      },
    );
  }
}
