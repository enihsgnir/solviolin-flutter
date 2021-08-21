import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotForTeacher extends StatefulWidget {
  const TimeSlotForTeacher({Key? key}) : super(key: key);

  @override
  _TimeSlotForTeacherState createState() => _TimeSlotForTeacherState();
}

class _TimeSlotForTeacherState extends State<TimeSlotForTeacher> {
  Client client = Get.find<Client>();

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();
    CalendarController calendarController = CalendarController();

    return GetBuilder<DataController>(
      builder: (controller) {
        return SfCalendar(
          view: CalendarView.week,
          dataSource: controller.reservationDataSource,
          controller: calendarController,
          onTap: (details) async {
            if (details.targetElement == CalendarElement.viewHeader) {
              controller.updateSelectedDay(details.date!);

              calendarController.displayDate = details.date!;
              calendarController.selectedDate = details.date!;
              if (calendarController.view == CalendarView.week) {
                calendarController.view = CalendarView.timelineDay;
              } else {
                calendarController.view = CalendarView.week;
              }
            }
          },
          headerStyle: CalendarHeaderStyle(
            textStyle: TextStyle(color: Colors.white, fontSize: 28),
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dateTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            dayTextStyle: TextStyle(color: Colors.white, fontSize: 16),
          ),
          appointmentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 9,
            endHour: 22.5,
            timeFormat: "HH:mm",
            timeInterval: const Duration(minutes: 30),
            timeIntervalWidth: 120,
            timeIntervalHeight: 60,
            timeTextStyle: TextStyle(fontSize: 16),
          ),
          resourceViewSettings: ResourceViewSettings(
            visibleResourceCount: 5,
            showAvatar: false,
            displayNameTextStyle: TextStyle(fontSize: 20),
          ),
          initialDisplayDate: controller.selectedDay,
          showDatePickerButton: true,
          showCurrentTimeIndicator: false,
          showNavigationArrow: true,
          allowedViews: [CalendarView.week, CalendarView.timelineDay],
        );
      },
    );
  }
}
