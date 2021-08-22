import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/teacher/teacher_list.dart';
import 'package:solviolin_admin/view/teacher/teacher_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  Client client = Get.find<Client>();

  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController(), tag: "Register");
  WorkDowController workDow = Get.put(WorkDowController());
  DateTimeController start = Get.put(DateTimeController(), tag: "Start");
  DateTimeController end = Get.put(DateTimeController(), tag: "End");

  SearchController search = Get.find<SearchController>(tag: "Teacher");

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar("강사"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: TeacherSearch(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
                color: Colors.grey,
                height: 0.5,
              ),
              Expanded(
                child: TeacherList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 36.r),
          onPressed: () {
            showDialog(
              context: context,
              barrierColor: Colors.black26,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "강사 스케줄 등록",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.r,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                        child: input("강사", teacher, "강사명을 입력하세요!"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                        child: branchDropdown("Register", "지점을 선택하세요!"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                        child: workDowDropdown("요일을 선택하세요!"),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                        child: pickTime(context, "시작시간", "Start", true),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                        child: pickTime(context, "종료시간", "End", true),
                      ),
                    ],
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.r,
                          horizontal: 16.r,
                        ),
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
                          await client.registerTeacher(
                            teacherID: teacher.text,
                            teacherBranch: branch.branchName!,
                            workDow: workDow.workDow!,
                            startTime: Duration(
                              hours: start.time!.hour,
                              minutes: start.time!.minute,
                            ),
                            endTime: Duration(
                              hours: end.time!.hour,
                              minutes: end.time!.minute,
                            ),
                          );

                          if (search.isSearched) {
                            await getTeachersData(
                              teacherID: search.text1,
                              branchName: search.text2,
                            );
                          }

                          Get.back();
                        } catch (e) {
                          showError(context, e.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: symbolColor,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.r,
                          horizontal: 16.r,
                        ),
                      ),
                      child: Text("등록", style: TextStyle(fontSize: 20.r)),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
