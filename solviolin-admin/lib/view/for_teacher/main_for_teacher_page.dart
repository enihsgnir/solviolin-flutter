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
  var _data = Get.find<DataController>();

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
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar(
          "메인",
          actions: [
            IconButton(
              onPressed: () => showLoading(() async {
                try {
                  await _data.getReservationForTeacherData();

                  await showMySnackbar(
                    message: "예약 목록을 불러왔습니다.",
                  );
                } catch (e) {
                  showError(e);
                }
              }),
              icon: Icon(CupertinoIcons.refresh, size: 24.r),
            ),
            IconButton(
              onPressed: () async {
                var initialDate = DateTime.now();
                DateTime? newDate;

                newDate = await showDatePicker(
                  context: context,
                  initialDate: _data.displayDate,
                  firstDate: DateTime(initialDate.year - 3),
                  lastDate: DateTime(initialDate.year + 1),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark(),
                      child: child!,
                    );
                  },
                );

                if (newDate != null) {
                  var _temp = _data.displayDate;
                  _data.updateDisplayDate(newDate);
                  _calendar.displayDate = newDate;

                  if (!isSameWeek(newDate, _temp)) {
                    showLoading(() async {
                      try {
                        await _data.getReservationForTeacherData();

                        if (_data.reservations.isEmpty) {
                          await showMySnackbar(
                            title: "알림",
                            message: "검색 조건에 해당하는 목록이 없습니다.",
                          );
                        }
                      } catch (e) {
                        showError(e);
                      }
                    });
                  }
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
