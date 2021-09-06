import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/picker.dart';

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
    return mySearch(
      contents: [
        branchDropdown(null, "지점을 선택하세요!"),
        myTextInput("강사", teacher),
        pickDateTime(context, "시작일", "Start"),
        pickDateTime(context, "종료일", "End"),
        Row(
          children: [
            myCheckBox(
              item: "오픈/클로즈",
              trueName: "오픈",
              falseName: "클로즈",
              reverse: true,
            ),
            myActionButton(
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
                  showError(e.toString());
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
