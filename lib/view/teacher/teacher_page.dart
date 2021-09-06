import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/teacher/teacher_list.dart';
import 'package:solviolin_admin/view/teacher/teacher_search.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/single.dart';

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
        appBar: myAppBar("강사 세부"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: TeacherSearch(),
              ),
              myDivider(),
              Expanded(
                child: TeacherList(),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(32.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                child: Icon(Icons.menu, size: 36.r),
                heroTag: null,
                onPressed: _showMenu,
              ),
              FloatingActionButton(
                child: Icon(Icons.add, size: 36.r),
                heroTag: null,
                onPressed: _showRegister,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future _showRegister() {
    return showMyDialog(
      context: context,
      title: "강사 스케줄 등록",
      contents: [
        myTextInput("강사", teacher, "강사명을 입력하세요!"),
        branchDropdown("Register", "지점을 선택하세요!"),
        workDowDropdown("요일을 선택하세요!"),
        pickTime(context, "시작시각", "Start", true),
        pickTime(context, "종료시각", "End", true),
      ],
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
          showError(e.toString());
        }
      },
      action: "등록",
      isScrolling: true,
    );
  }

  Future _showMenu() {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                Get.toNamed("/teacher/canceled");
              },
              child: Text("취소 내역", style: TextStyle(fontSize: 24.r)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
                Get.toNamed("/teacher/salary");
              },
              child: Text("급여 계산", style: TextStyle(fontSize: 24.r)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
            },
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24.r)),
          ),
        );
      },
    );
  }
}
