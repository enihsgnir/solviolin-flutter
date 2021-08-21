import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
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
  CheckController status = Get.put(CheckController());

  SearchController search = Get.find<SearchController>(tag: "Control");

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 24.r),
            child: branchDropdown(null, "지점을 선택하세요!"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: input("강사", teacher),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: pickDateTime(context, "시작일", "Start"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: pickDateTime(context, "종료일", "End"),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
                child: check(
                  item: "오픈/클로즈",
                  trueName: "오픈",
                  falseName: "클로즈",
                  reverse: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 60.r),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                  ),
                  onPressed: () async {
                    try {
                      search.text1 = branch.branchName!;
                      search.text2 = teacher.text == "" ? null : teacher.text;
                      search.dateTime1 = start.dateTime;
                      search.dateTime2 = end.dateTime;
                      search.number1 = status.result;

                      await getControlsData(
                        branchName: search.text1!,
                        teacherID: search.text2,
                        startDate: search.dateTime1,
                        endDate: search.dateTime2,
                        status: search.number1,
                      );

                      search.isSearched = true;
                    } catch (e) {
                      showError(context, e.toString());
                    }
                  },
                  child: Text("검색", style: TextStyle(fontSize: 20.r)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
