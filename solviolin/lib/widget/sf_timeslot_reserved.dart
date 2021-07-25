import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/notification.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SfTimeslotReserved extends StatefulWidget {
  final Stream<DateTime> stream;

  const SfTimeslotReserved({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  _SfTimeslotReservedState createState() => _SfTimeslotReservedState();
}

class _SfTimeslotReservedState extends State<SfTimeslotReserved> {
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
    Get.find<DataController>();
    return GetBuilder<DataController>(
      builder: (controller) {
        return SfCalendar(
          view: CalendarView.day,
          minDate: _selectedDay,
          maxDate: _selectedDay.add(Duration(milliseconds: 100)),
          headerHeight: 0,
          viewHeaderHeight: 0,
          // timeZone: "Korea Standard Time",
          selectionDecoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          dataSource: ReservationDataSource(controller.myValidReservations),
          specialRegions: getTimeRegions(),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 8.5,
            endHour: 18.5,
            timeFormat: "h:mm",
            timeInterval: Duration(minutes: 30),
            timeTextStyle: TextStyle(
              color: Colors.greenAccent,
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
          onTap: (details) async {
            details.appointments == null
                ? modalReserve(context, details)
                : modalCancelOrExtend(context);
          },
        );
      },
    );
  }
}
