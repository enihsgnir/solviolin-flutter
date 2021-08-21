import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class TeacherSearch extends StatefulWidget {
  const TeacherSearch({Key? key}) : super(key: key);

  @override
  _TeacherSearchState createState() => _TeacherSearchState();
}

class _TeacherSearchState extends State<TeacherSearch> {
  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController());

  SearchController search = Get.find<SearchController>();

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.r, 8.r, 8.r, 24.r),
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
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: input("강사", teacher),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 24.r),
                child: branchDropdown(null, "지점을 선택하세요!"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 36.r),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                  ),
                  onPressed: () async {
                    try {
                      String teacherID = teacher.text;
                      await getTeachersData(
                        teacherID: teacherID == "" ? null : teacherID,
                        branchName: branch.branchName,
                      );
                    } catch (e) {
                      showErrorMessage(context, e.toString());
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
