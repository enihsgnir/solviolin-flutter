import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/control/control_list.dart';
import 'package:solviolin_admin/view/control/control_search.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';
import 'package:solviolin_admin/widget/selection.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  Client client = Get.put(Client());
  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController(), tag: "Register");
  DateTimeController start =
      Get.put(DateTimeController(), tag: "StartRegister");
  DateTimeController end = Get.put(DateTimeController(), tag: "EndRegister");
  CheckController _status = Get.put(CheckController());
  bool cancelInClose = false;

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
                padding: const EdgeInsets.all(8),
                child: ControlSearch(),
              ),
              Expanded(
                child: ControlList(),
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
                    "오픈/클로즈 등록",
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
                        child: pickDateTime(context, "시작일", "StartRegister"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: pickDateTime(context, "종료일", "EndRegister"),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: check(
                          item: "오픈/클로즈",
                          trueName: "오픈",
                          falseName: "클로즈",
                          reverse: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Container(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 240,
                              child: Text(
                                "기간 내 취소",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: cancelInClose,
                              onChanged: (value) {
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
                              start.dateTime == null ||
                              end.dateTime == null
                          ? null
                          : () async {
                              try {
                                await client.registerControl(
                                  teacherID: teacher.text,
                                  branchName: branch.branchName!,
                                  controlStart: start.dateTime!,
                                  controlEnd: end.dateTime!,
                                  status: _status.result!,
                                  cancelInClose: cancelInClose ? 1 : 0,
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
