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
    final deviceHeight = MediaQuery.of(context).size.height;

    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(kToday.year, kToday.month - 6, 1),
          lastDay: DateTime(kToday.year, kToday.month + 7, 0),
          weekendDays: const [DateTime.sunday],
          availableCalendarFormats: const {CalendarFormat.month: "Month"},
          pageJumpingEnabled: true,
          sixWeekMonthsEnforced: true,
          rowHeight: 72,
          daysOfWeekHeight: 24,
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextFormatter: (date, locale) =>
                DateFormat.yMMM().format(date),
            titleTextStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              size: 32,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              size: 32,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0],
            weekdayStyle: TextStyle(
              color: const Color(0xFF4F4F4F),
              fontSize: 20,
            ),
            weekendStyle: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayTextStyle: TextStyle(
              color: kToday.weekday == 7 ? const Color(0xFFFAFAFA) : Colors.red,
              fontSize: 24,
            ),
            todayDecoration: BoxDecoration(
                color:
                    kToday.weekday == 7 ? Colors.red : const Color(0xFFFAFAFA),
                shape: BoxShape.circle),
            selectedTextStyle: TextStyle(
              color: _selectedDay.weekday == 7
                  ? Colors.red
                  : const Color(0xFFFAFAFA),
              fontSize: 24,
            ),
            selectedDecoration: BoxDecoration(
              color: const Color.fromRGBO(227, 214, 208, 0.15),
              shape: BoxShape.circle,
            ),
            outsideTextStyle: TextStyle(
              color: const Color(0xFFAEAEAE),
              fontSize: 20,
            ),
            disabledTextStyle: TextStyle(
              color: const Color(0xFFBFBFBF),
              fontSize: 20,
            ),
            holidayTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            holidayDecoration: BoxDecoration(
              color: const Color.fromRGBO(96, 128, 104, 100),
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: Colors.red,
              fontSize: 24,
            ),
            defaultTextStyle: TextStyle(
              color: Colors.white70,
              fontSize: 24,
            ),
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
            await getSelectedDayData(selectedDay);

            controller.updateSelectedDay(selectedDay);
            controller.updateFocusedDay(focusedDay);
          },
          onPageChanged: (focusedDay) async {
            _focusedDay = focusedDay;
            await getChangedPageData(focusedDay);

            controller.updateFocusedDay(focusedDay);
          },
        );
      },
    );
  }
}
