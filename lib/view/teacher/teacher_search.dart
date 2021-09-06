import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/search.dart';

class TeacherSearch extends StatefulWidget {
  const TeacherSearch({Key? key}) : super(key: key);

  @override
  _TeacherSearchState createState() => _TeacherSearchState();
}

class _TeacherSearchState extends State<TeacherSearch> {
  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController());

  SearchController search = Get.find<SearchController>(tag: "Teacher");

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mySearch(
      padding: EdgeInsets.symmetric(vertical: 16.r),
      contents: [
        myTextInput("강사", teacher),
        Row(
          children: [
            branchDropdown(null, "지점을 선택하세요!"),
            myActionButton(
              onPressed: () async {
                try {
                  search.text1 = teacher.text == "" ? null : teacher.text;
                  search.text2 = branch.branchName;

                  await getTeachersData(
                    teacherID: search.text1,
                    branchName: search.text2,
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
