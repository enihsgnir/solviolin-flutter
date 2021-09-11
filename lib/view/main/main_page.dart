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
  var _controller = Get.find<DataController>();

  var _calendar = Get.put(CalendarController(), tag: "/admin");

  var search = Get.put(CacheController(), tag: "/search");

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
        resizeToAvoidBottomInset: false,
        appBar: myAppBar(
          "메인",
          actions: [
            IconButton(
              onPressed: () => showLoading(() async {
                try {
                  await _getSearchedReservationsData();
                } catch (e) {
                  showError(e.toString());
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

                if (newDate != null) {
                  _controller.updateDisplayDate(newDate);
                  _calendar.displayDate = newDate;

                  if (!isSameWeek(newDate, _controller.displayDate)) {
                    showLoading(() async {
                      try {
                        await _getSearchedReservationsData();
                      } catch (e) {
                        showError(e.toString());
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
        branchDropdown("/search", "지점을 선택하세요!"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await getReservationData(
            displayDate: _controller.displayDate,
            branchName: search.branchName!,
            userID: textEdit(search.edit1),
            teacherID: textEdit(search.edit2),
          );

          search.isSearched = true;
          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      action: "검색",
      isScrolling: true,
    );
  }

  Future<void> _getSearchedReservationsData() async {
    if (search.isSearched) {
      await getReservationData(
        displayDate: _controller.displayDate,
        branchName: search.branchName!,
        userID: textEdit(search.edit1),
        teacherID: textEdit(search.edit2),
      );
    }
  }
}
