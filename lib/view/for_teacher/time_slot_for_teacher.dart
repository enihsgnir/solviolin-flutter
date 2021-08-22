import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotForTeacher extends StatefulWidget {
  const TimeSlotForTeacher({Key? key}) : super(key: key);

  @override
  _TimeSlotForTeacherState createState() => _TimeSlotForTeacherState();
}

class _TimeSlotForTeacherState extends State<TimeSlotForTeacher> {
  Client client = Get.find<Client>();

  CalendarController calendarController = Get.find<CalendarController>();

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return SfCalendar(
          view: CalendarView.week,
          dataSource: controller.reservationDataSource,
          controller: calendarController,
          onTap: (details) async {
            if (details.targetElement == CalendarElement.viewHeader) {
              if (calendarController.view == CalendarView.week) {
                calendarController.view = CalendarView.timelineDay;
              } else {
                calendarController.view = CalendarView.week;
              }

              calendarController.displayDate = details.date!;
              controller.updateDisplayDate(calendarController.displayDate!);
            }
          },
          onViewChanged: (details) async {
            if (!isSameWeek(
                calendarController.displayDate!, controller.displayDate)) {
              controller.updateDisplayDate(calendarController.displayDate!);

              try {
                await getReservationDataForTeacher(
                  displayDate: controller.displayDate,
                  branchName: controller.profile.branchName,
                  teacherID: controller.profile.userID,
                );
              } catch (e) {
                showError(context, e.toString());
              }
            }
          },
          headerStyle: CalendarHeaderStyle(
            textStyle: TextStyle(color: Colors.white, fontSize: 28.r),
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dateTextStyle: TextStyle(color: Colors.white, fontSize: 20.r),
            dayTextStyle: TextStyle(color: Colors.white, fontSize: 16.r),
          ),
          appointmentTextStyle: TextStyle(color: Colors.white, fontSize: 16.r),
          timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 9,
            endHour: 22.5,
            timeFormat: "HH:mm",
            timeInterval: const Duration(minutes: 30),
            timeIntervalWidth: 120.r,
            timeIntervalHeight: 60.r,
            timeTextStyle: TextStyle(fontSize: 16.r),
          ),
          resourceViewSettings: ResourceViewSettings(
            visibleResourceCount: 2,
            showAvatar: false,
            displayNameTextStyle: TextStyle(fontSize: 20.r),
          ),
          initialDisplayDate: controller.displayDate,
          showCurrentTimeIndicator: false,
          showNavigationArrow: true,
          allowedViews: [CalendarView.week, CalendarView.timelineDay],
        );
      },
    );
  }
}
