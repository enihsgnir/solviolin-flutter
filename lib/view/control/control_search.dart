import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class ControlSearch extends StatefulWidget {
  const ControlSearch({Key? key}) : super(key: key);

  @override
  _ControlSearchState createState() => _ControlSearchState();
}

class _ControlSearchState extends State<ControlSearch> {
  BranchController branch = Get.put(BranchController());
  TextEditingController teacher = TextEditingController();
  DateTimeController start = Get.put(DateTimeController(), tag: "Start");
  DateTimeController end = Get.put(DateTimeController(), tag: "End");
  CheckController _status = Get.put(CheckController());

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24),
            child: branchDropdown(),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24, top: 12),
            child: input("강사", teacher),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24, top: 12),
            child: pickDateTime(context, "시작일", "Start"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 24, top: 12),
            child: pickDateTime(context, "종료일", "End"),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24, top: 12),
                child: check(
                  item: "오픈/클로즈",
                  trueName: "오픈",
                  falseName: "클로즈",
                  reverse: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(96, 128, 104, 100),
                  ),
                  onPressed: branch.branchName == null
                      ? null
                      : () async {
                          try {
                            String teacherID = teacher.text;
                            await getControlsData(
                              branchName: branch.branchName!,
                              teacherID: teacherID == "" ? null : teacherID,
                              startDate: start.dateTime,
                              endDate: end.dateTime,
                              status: _status.result,
                            );
                          } catch (e) {
                            showErrorMessage(context, e.toString());
                          }
                        },
                  child: Text(
                    "검색",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
