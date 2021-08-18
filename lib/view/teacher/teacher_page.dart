import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/teacher/teacher_list.dart';
import 'package:solviolin_admin/view/teacher/teacher_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';
import 'package:solviolin_admin/widget/selection.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  Client client = Get.put(Client());
  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController(), tag: "Register");
  WorkDowController workDow = Get.put(WorkDowController());
  DateTimeController start = Get.put(DateTimeController(), tag: "Start");
  DateTimeController end = Get.put(DateTimeController(), tag: "End");

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
        appBar: appBar("선생님"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TeacherSearch(),
              ),
              Expanded(
                child: TeacherList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              barrierColor: Colors.black26,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "선생님 스케줄 등록",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: input("강사", teacher, "강사명을 입력하세요!"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: branchDropdown("Register", "지점을 선택하세요!"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: workDowDropdown("요일을 선택하세요!"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: pickDateTime(context, "시작일", "Start"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: pickDateTime(context, "종료일", "End"),
                      ),
                    ],
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      ),
                      child: Text(
                        "취소",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: teacher.text == "" ||
                              branch.branchName == null ||
                              workDow.workDow == null ||
                              start.time == null ||
                              end.time == null
                          ? null
                          : () async {
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
                              } catch (e) {
                                showErrorMessage(context, e.toString());
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(96, 128, 104, 100),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      ),
                      child: Text(
                        "등록",
                        style: TextStyle(fontSize: 20),
                      ),
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
