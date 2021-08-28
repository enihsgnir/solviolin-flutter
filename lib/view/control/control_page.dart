import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/control/control_list.dart';
import 'package:solviolin_admin/view/control/control_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  Client client = Get.find<Client>();

  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController(), tag: "Register");
  DateTimeController start =
      Get.put(DateTimeController(), tag: "StartRegister");
  DateTimeController end = Get.put(DateTimeController(), tag: "EndRegister");
  StatusType status = StatusType.open;
  CancelInCloseType cancelInClose = CancelInCloseType.none;

  SearchController search = Get.find<SearchController>(tag: "Control");

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
        appBar: appBar("오픈/클로즈"),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.r),
                child: ControlSearch(),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
                color: Colors.grey,
                height: 0.5,
              ),
              Expanded(
                child: ControlList(),
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

  Future _showRegister() {
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text(
                  "오픈/클로즈 등록",
                  style: TextStyle(color: Colors.white, fontSize: 28.r),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
                      child: input("강사", teacher, "강사명을 입력하세요!"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
                      child: branchDropdown("Register", "지점을 선택하세요!"),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
                      child: pickDateTime(
                        context,
                        "시작일",
                        "StartRegister",
                        true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 6.r, 12.r, 0),
                      child: pickDateTime(
                        context,
                        "종료일",
                        "EndRegister",
                        true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 20.r),
                        child: Row(
                          children: [
                            Container(
                              width: 120.r,
                              child: label("오픈/클로즈", true),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.r),
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: StatusType.open,
                                        groupValue: status,
                                        onChanged: (StatusType? value) {
                                          setState(() {
                                            status = value!;
                                          });
                                        },
                                      ),
                                      Text("오픈"),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.r),
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: StatusType.close,
                                        groupValue: status,
                                        onChanged: (StatusType? value) {
                                          setState(() {
                                            status = value!;
                                          });
                                        },
                                      ),
                                      Text("클로즈"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 20.r),
                        child: Row(
                          children: [
                            Container(
                              width: 110.r,
                              child: label("기간 내", true),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.r),
                                  child: Column(
                                    children: [
                                      Text("유지"),
                                      Radio(
                                        value: CancelInCloseType.none,
                                        groupValue: cancelInClose,
                                        onChanged: (CancelInCloseType? value) {
                                          setState(() {
                                            cancelInClose = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.r),
                                  child: Column(
                                    children: [
                                      Text("취소"),
                                      Radio(
                                        value: CancelInCloseType.cancel,
                                        groupValue: cancelInClose,
                                        onChanged: (CancelInCloseType? value) {
                                          setState(() {
                                            cancelInClose = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.r),
                                  child: Column(
                                    children: [
                                      Text("삭제"),
                                      Radio(
                                        value: CancelInCloseType.delete,
                                        groupValue: cancelInClose,
                                        onChanged: (CancelInCloseType? value) {
                                          setState(() {
                                            cancelInClose = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
                    ),
                    child: Text(
                      "취소",
                      style: TextStyle(color: Colors.white, fontSize: 20.r),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await client.registerControl(
                          teacherID: teacher.text,
                          branchName: branch.branchName!,
                          controlStart: start.dateTime!,
                          controlEnd: end.dateTime!,
                          status: status == StatusType.open ? 0 : 1,
                          cancelInClose: cancelInClose == CancelInCloseType.none
                              ? 0
                              : cancelInClose == CancelInCloseType.cancel
                                  ? 1
                                  : 2,
                        );

                        if (search.isSearched) {
                          await getControlsData(
                            branchName: search.text1!,
                            teacherID: search.text2,
                            startDate: search.dateTime1,
                            endDate: search.dateTime2,
                            status: search.number1,
                          );
                        }

                        Get.back();
                      } catch (e) {
                        showError(context, e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: symbolColor,
                      padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 12.r),
                    ),
                    child: Text("등록", style: TextStyle(fontSize: 20.r)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

enum StatusType {
  open,
  close,
}

enum CancelInCloseType {
  none,
  cancel,
  delete,
}
