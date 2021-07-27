import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/notification.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeslotReserved extends StatefulWidget {
  final Stream<DateTime> stream;

  const TimeslotReserved({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  _TimeslotReservedState createState() => _TimeslotReservedState();
}

class _TimeslotReservedState extends State<TimeslotReserved> {
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.stream.listen((selectedDay) {
      setState(() {
        _selectedDay = selectedDay;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    final _textHeight = _deviceHeight / MediaQuery.of(context).textScaleFactor;
    Get.find<DataController>();
    DateTime _minDate =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    DateTime _maxDate =
        _minDate.add(Duration(hours: 23, minutes: 59, seconds: 59));

    return GetBuilder<DataController>(
      builder: (controller) {
        return Container(
          height: _deviceHeight * 0.8,
          child: SfCalendar(
            view: CalendarView.day,
            minDate: _minDate,
            maxDate: _maxDate,
            headerHeight: 0,
            viewHeaderHeight: 0,
            // timeZone: "Korea Standard Time",
            selectionDecoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            dataSource: ReservationDataSource(controller.myValidReservations),
            specialRegions: getTimeRegions(),
            timeSlotViewSettings: TimeSlotViewSettings(
              startHour: 9,
              endHour: 22.5,
              timeFormat: "HH:mm",
              timeInterval: const Duration(minutes: 30),
              timeIntervalHeight: _deviceHeight * 0.05,
              timeTextStyle: TextStyle(
                color: Colors.greenAccent,
                fontSize: _textHeight * 0.015,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: (details) {
              if (details.targetElement == CalendarElement.calendarCell) {
                details.appointments == null
                    ? modalReserve(context, details)
                    : modalCancelOrExtend(context, details);
              }
            },
          ),
        );
      },
    );
  }
}
