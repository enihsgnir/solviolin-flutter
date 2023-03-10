import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
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
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/teacher");
  var register = Get.put(CacheController(), tag: "/register");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar("강사 스케줄"),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 36.r),
          onPressed: _showRegister,
        ),
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
            branchDropdown("/search/teacher"),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  _data.teachers = await _client.getTeachers(
                    teacherID: textEdit(search.edit1),
                    branchName: search.branchName,
                  );
                  _data.update();

                  search.isSearched = true;

                  if (_data.teachers.isEmpty) {
                    await showMySnackbar(
                      title: "알림",
                      message: "검색 조건에 해당하는 목록이 없습니다.",
                    );
                  }
                } catch (e) {
                  showError(e);
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _teacherList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: _data.teachers.length,
          itemBuilder: (context, index) {
            var teacher = _data.teachers[index];

            return mySlidableCard(
              slideActions: [
                mySlideAction(
                  context: context,
                  icon: CupertinoIcons.delete,
                  item: "삭제",
                  onTap: () => showMyDialog(
                    title: "강사 스케줄 삭제",
                    contents: [
                      Text("정말 삭제하시겠습니까?"),
                    ],
                    onPressed: () => showLoading(() async {
                      try {
                        await _client.deleteTeacher(teacher.id);

                        _data.teachers = await _client.getTeachers(
                          teacherID: textEdit(search.edit1),
                          branchName: search.branchName,
                        );
                        _data.update();

                        Get.back();

                        await showMySnackbar(
                          message: "강사 스케줄 삭제에 성공했습니다.",
                        );
                      } catch (e) {
                        showError(e);
                      }
                    }),
                  ),
                ),
              ],
              children: [
                Text(teacher.toString()),
              ],
            );
          },
        );
      },
    );
  }

  Future _showRegister() {
    FocusScope.of(context).requestFocus(FocusNode());
    register.reset();
    register.branchName = _data.profile.branchName;

    return showMyDialog(
      title: "강사 스케줄 등록",
      contents: [
        myTextInput("강사", register.edit1, isMandatory: true),
        branchDropdown("/register", true),
        workDowDropdown("/register", true),
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
            _data.teachers = await _client.getTeachers(
              teacherID: textEdit(search.edit1),
              branchName: search.branchName,
            );
            _data.update();
          }

          Get.back();

          await showMySnackbar(message: "신규 강사 스케줄 등록에 성공했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
      action: "등록",
      isScrollable: true,
    );
  }
}
