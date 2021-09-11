import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSlotForTeacher extends StatefulWidget {
  const TimeSlotForTeacher({Key? key}) : super(key: key);

  @override
  _TimeSlotForTeacherState createState() => _TimeSlotForTeacherState();
}

class _TimeSlotForTeacherState extends State<TimeSlotForTeacher> {
  var _calendar = Get.find<CalendarController>(tag: "/teacher");

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return SfCalendar(
          view: CalendarView.week,
          dataSource: controller.reservationDataSource,
          controller: _calendar,
          onTap: (details) {
            if (details.targetElement == CalendarElement.viewHeader) {
              if (_calendar.view == CalendarView.week) {
                _calendar.view = CalendarView.timelineDay;
              } else {
                _calendar.view = CalendarView.week;
              }

              _calendar.displayDate = details.date!;
              controller.updateDisplayDate(_calendar.displayDate!);
            }
          },
          onViewChanged: (details) {
            if (!isSameWeek(_calendar.displayDate!, controller.displayDate)) {
              controller.updateDisplayDate(_calendar.displayDate!);

              showLoading(() async {
                try {
                  await getReservationDataForTeacher(
                    displayDate: controller.displayDate,
                    teacherID: controller.profile.userID,
                  );
                } catch (e) {
                  showError(e.toString());
                }
              });
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
