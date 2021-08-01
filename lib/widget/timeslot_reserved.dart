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
    final deviceHeight = MediaQuery.of(context).size.height;

    Get.find<DataController>();

    DateTime minDate =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    DateTime maxDate =
        minDate.add(Duration(hours: 23, minutes: 59, seconds: 59));

    return GetBuilder<DataController>(
      builder: (controller) {
        return Container(
          height: deviceHeight * 0.8,
          child: SfCalendar(
            view: CalendarView.day,
            minDate: minDate,
            maxDate: maxDate,
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
              timeIntervalHeight: deviceHeight * 0.05,
              timeTextStyle: TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
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
