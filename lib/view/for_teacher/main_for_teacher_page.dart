import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/view/for_teacher/time_slot_for_teacher.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/single.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainForTeacherPage extends StatefulWidget {
  const MainForTeacherPage({Key? key}) : super(key: key);

  @override
  _MainForTeacherPageState createState() => _MainForTeacherPageState();
}

class _MainForTeacherPageState extends State<MainForTeacherPage> {
  var _controller = Get.find<DataController>();

  var _calendar = Get.put(CalendarController(), tag: "/teacher");

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar(
          "메인",
          actions: [
            IconButton(
              onPressed: () => showLoading(() async {
                try {
                  await getReservationDataForTeacher(
                    displayDate: _controller.displayDate,
                    teacherID: _controller.profile.userID,
                  );
                } catch (e) {
                  showError(e.toString());
                }
              }),
              icon: Icon(CupertinoIcons.refresh, size: 24.r),
            ),
            IconButton(
              onPressed: () async {
                final initialDate = DateTime.now();
                DateTime? newDate;

                newDate = await showDatePicker(
                  context: context,
                  initialDate: _controller.displayDate,
                  firstDate: DateTime(initialDate.year - 3),
                  lastDate: DateTime(initialDate.year + 1),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        textTheme: TextTheme(
                          headline5: TextStyle(fontSize: 24.r),
                          subtitle2: TextStyle(fontSize: 16.r),
                          caption: TextStyle(fontSize: 16.r),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (newDate != null &&
                    !isSameWeek(newDate, _controller.displayDate)) {
                  _controller.updateDisplayDate(newDate);
                  _calendar.displayDate = newDate;

                  showLoading(() async {
                    try {
                      await getReservationDataForTeacher(
                        displayDate: _controller.displayDate,
                        teacherID: _controller.profile.userID,
                      );
                    } catch (e) {
                      showError(e.toString());
                    }
                  });
                }
              },
              icon: Icon(Icons.calendar_today, size: 24.r),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            child: TimeSlotForTeacher(),
          ),
        ),
      ),
    );
  }
}
