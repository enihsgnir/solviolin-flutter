import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/view/main/time_slot.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/single.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _data = Get.find<DataController>();

  var _calendar = Get.put(CalendarController(), tag: "/admin");

  var search = Get.find<CacheController>(tag: "/search/main");

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
        resizeToAvoidBottomInset: false,
        appBar: myAppBar(
          "예약 슬롯",
          actions: [
            IconButton(
              onPressed: () => showLoading(() async {
                try {
                  await _getSearchedReservationsData();
                } catch (e) {
                  showError(e);
                }
              }),
              icon: Icon(CupertinoIcons.refresh, size: 24.r),
            ),
            IconButton(
              onPressed: _showSearch,
              icon: Icon(CupertinoIcons.slider_horizontal_3, size: 24.r),
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

                if (newDate != null) {
                  var _temp = _data.displayDate;
                  _data.updateDisplayDate(newDate);
                  _calendar.displayDate = newDate;

                  if (!isSameWeek(newDate, _temp)) {
                    showLoading(() async {
                      try {
                        await _getSearchedReservationsData();
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
            child: TimeSlot(),
          ),
        ),
      ),
    );
  }

  Future _showSearch() {
    return showMyDialog(
      title: "검색",
      contents: [
        myTextInput("수강생", search.edit1),
        myTextInput("강사", search.edit2),
        branchDropdown("/search/main", true),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _data.getReservationData(
            branchName: search.branchName!,
            userID: textEdit(search.edit1),
            teacherID: textEdit(search.edit2),
          );

          search.isSearched = true;
          Get.back();

          if (_data.reservations.isEmpty) {
            await showMySnackbar(
              title: "알림",
              message: "검색 조건에 해당하는 목록이 없습니다.",
            );
          }
        } catch (e) {
          showError(e);
        }
      }),
      action: "검색",
      isScrollable: true,
    );
  }

  Future<void> _getSearchedReservationsData() async {
    if (search.isSearched) {
      await _data.getReservationData(
        branchName: search.branchName!,
        userID: textEdit(search.edit1),
        teacherID: textEdit(search.edit2),
      );
    } else {
      await showMySnackbar(
        title: "알림",
        message: "검색값이 없습니다.",
      );
    }
  }
}
