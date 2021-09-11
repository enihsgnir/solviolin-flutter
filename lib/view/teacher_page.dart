import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  var _client = Get.find<Client>();

  var search = Get.put(CacheController(), tag: "/search");
  var register = Get.put(CacheController(), tag: "/register");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar("강사 세부"),
        body: SafeArea(
          child: Column(
            children: [
              _teacherSearch(),
              myDivider(),
              Expanded(
                child: _teacherList(),
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

  Widget _teacherSearch() {
    return mySearch(
      padding: EdgeInsets.symmetric(vertical: 16.r),
      contents: [
        myTextInput("강사", search.edit1),
        Row(
          children: [
            branchDropdown("/search", "지점을 선택하세요!"),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  await getTeachersData(
                    teacherID: textEdit(search.edit1),
                    branchName: search.branchName,
                  );

                  search.isSearched = true;
                } catch (e) {
                  showError(e.toString());
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _teacherList() {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.teachers.length,
          itemBuilder: (context, index) {
            var teacher = controller.teachers[index];

            return mySlidableCard(
              slideActions: [
                mySlideAction(
                  context: context,
                  icon: CupertinoIcons.delete,
                  item: "삭제",
                  onTap: () => showMyDialog(
                    context: context,
                    title: "강사 스케줄 삭제",
                    contents: [
                      Text("정말 삭제하시겠습니까?"),
                    ],
                    onPressed: () => showLoading(() async {
                      try {
                        await _client.deleteTeacher(teacher.id);

                        await getTeachersData(
                          teacherID: textEdit(search.edit1),
                          branchName: search.branchName,
                        );

                        Get.back();
                      } catch (e) {
                        showError(e.toString());
                      }
                    }),
                  ),
                ),
              ],
              children: [
                Text("${teacher.teacherID} / ${teacher.branchName}"),
                Text("${dowToString(teacher.workDow)}" +
                    " / ${timeToString(teacher.startTime)}" +
                    " : ${timeToString(teacher.endTime)}"),
              ],
            );
          },
        );
      },
    );
  }

  Future _showRegister() {
    FocusScope.of(context).unfocus();
    register.reset();

    return showMyDialog(
      context: context,
      title: "강사 스케줄 등록",
      contents: [
        myTextInput("강사", register.edit1, "강사명을 입력하세요!"),
        branchDropdown("/register", "지점을 선택하세요!"),
        workDowDropdown("/register", "요일을 선택하세요!"),
        pickTime(
          context: context,
          item: "시작시간",
          tag: "/register",
          index: 0,
          isMandatory: true,
        ),
        pickTime(
          context: context,
          item: "종료시간",
          tag: "/register",
          index: 1,
          isMandatory: true,
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerTeacher(
            teacherID: textEdit(register.edit1)!,
            teacherBranch: register.branchName!,
            workDow: register.workDow!,
            startTime: timeOfDayToDuration(register.time[0]!),
            endTime: timeOfDayToDuration(register.time[1]!),
          );

          if (search.isSearched) {
            await getTeachersData(
              teacherID: textEdit(search.edit1),
              branchName: search.branchName,
            );
          }

          Get.back();
        } catch (e) {
          showError(e.toString());
        }
      }),
      action: "등록",
      isScrolling: true,
    );
  }

  Future _showMenu() {
    FocusScope.of(context).unfocus();

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
            onPressed: Get.back,
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24.r)),
          ),
        );
      },
    );
  }
}
