import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DayView extends StatefulWidget {
  const DayView({Key? key}) : super(key: key);

  @override
  _DayViewState createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return Scaffold(
      appBar: appBar("일간 스케줄"),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            return SfCalendar(
              view: CalendarView.timelineDay,
              dataSource: controller.reservationDataSource,
              headerStyle: CalendarHeaderStyle(
                textAlign: TextAlign.right,
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                dateTextStyle: TextStyle(color: Colors.white, fontSize: 24),
                dayTextStyle: TextStyle(color: Colors.white, fontSize: 24),
              ),
              appointmentTextStyle:
                  TextStyle(color: Colors.white, fontSize: 16),
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 9,
                endHour: 22.5,
                timeFormat: "HH:mm",
                timeInterval: const Duration(minutes: 30),
                timeIntervalWidth: 120,
                timeTextStyle: TextStyle(fontSize: 16),
              ),
              resourceViewSettings: ResourceViewSettings(
                visibleResourceCount: 5,
                showAvatar: false,
                displayNameTextStyle: TextStyle(fontSize: 20),
              ),
              initialDisplayDate: controller.selectedDay,
              showCurrentTimeIndicator: false,
            );
          },
        ),
      ),
    );
  }
}
