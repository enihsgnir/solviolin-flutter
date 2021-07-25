import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/format.dart';

class HourlyReserved extends StatefulWidget {
  final Stream<DateTime> stream;

  const HourlyReserved({
    Key? key,
    required this.stream,
  }) : super(key: key);

  @override
  _HourlyReservedState createState() => _HourlyReservedState();
}

class _HourlyReservedState extends State<HourlyReserved> {
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
    return GetBuilder(
      builder: (controller) {
        return DayView(
          events: getWeekViewEvents(),
          date: _selectedDay,
          hoursColumnStyle: HoursColumnStyle(
            timeFormatter: (time) => "${time.hour}:${time.minute}",
            textStyle: TextStyle(
              color: Colors.greenAccent,
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
            interval: Duration(minutes: 30),
          ),
          dayBarStyle: DayBarStyle(
            dateFormatter: (year, month, day) =>
                "$day. ${dowToString(DateTime(year, month, day).weekday)}",
            textAlignment: Alignment.centerLeft,
          ),
          minimumTime: HourMinute(hour: 8, minute: 30),
          maximumTime: HourMinute(hour: 18, minute: 30),
          initialTime: HourMinute(
            hour: DateTime.now().hour,
            minute: DateTime.now().minute,
          ),
        );
      },
    );
  }
}
