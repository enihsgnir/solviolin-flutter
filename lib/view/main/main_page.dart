import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/main/time_slot.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Client client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  TextEditingController user = TextEditingController();
  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController());

  SearchController search = Get.find<SearchController>(tag: "Main");

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
    user.dispose();
    teacher.dispose();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    Get.put(DateTimeController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar(
          "메인",
          actions: [
            IconButton(
              onPressed: () async {
                try {
                  if (search.isSearched) {
                    await getReservationData(
                      focusedDay: search.dateTime1!,
                      branchName: search.text1!,
                      userID: search.text2,
                      teacherID: search.text3,
                    );
                  }
                } catch (e) {
                  showErrorMessage(context, e.toString());
                }
              },
              icon: Icon(CupertinoIcons.refresh),
            ),
            Container(
              padding: EdgeInsets.all(16.r),
              child: InkWell(
                child: Icon(CupertinoIcons.slider_horizontal_3),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black26,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: AlertDialog(
                          title: Text(
                            "검색",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.r,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                                child: input("수강생", user),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                                child: input("강사", teacher),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0.r),
                                child: branchDropdown(null, "지점을 선택하세요!"),
                              ),
                            ],
                          ),
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12),
                              ),
                              child: Text(
                                "취소",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.r,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  search.dateTime1 = _controller.selectedDay;
                                  search.text1 = branch.branchName;
                                  search.text2 =
                                      user.text == "" ? null : user.text;
                                  search.text3 =
                                      teacher.text == "" ? null : teacher.text;

                                  await getReservationData(
                                    focusedDay: search.dateTime1!,
                                    branchName: search.text1!,
                                    userID: search.text2,
                                    teacherID: search.text3,
                                  );
                                  Get.back();

                                  search.isSearched = true;
                                } catch (e) {
                                  showErrorMessage(context, e.toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: symbolColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.r,
                                  horizontal: 16.r,
                                ),
                              ),
                              child: Text(
                                "검색",
                                style: TextStyle(fontSize: 20.r),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                DateTimeController controller = Get.find<DateTimeController>();

                final DateTime initialDate = DateTime.now();
                DateTime? newDate;

                newDate = await showDatePicker(
                  context: context,
                  initialDate: controller.date ?? initialDate,
                  firstDate:
                      DateTime(initialDate.year, initialDate.month - 5, 1),
                  lastDate: _controller.currentTerm[0].termEnd
                      .add(const Duration(hours: 23, minutes: 59, seconds: 59)),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        textTheme: TextTheme(
                          headline5: TextStyle(fontSize: 24),
                          subtitle2: TextStyle(fontSize: 16),
                          caption: TextStyle(fontSize: 16),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                if (newDate != null) {
                  controller.updateDate(newDate);
                }
              },
              icon: Icon(Icons.calendar_today),
            ),
          ],
        ),
        body: SafeArea(
          child: GetBuilder<DataController>(
            builder: (controller) {
              return Container(
                height: double.infinity,
                child: TimeSlot(),
              );
            },
          ),
        ),
      ),
    );
  }
}
