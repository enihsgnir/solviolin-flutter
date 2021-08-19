import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class TeacherSearch extends StatefulWidget {
  const TeacherSearch({Key? key}) : super(key: key);

  @override
  _TeacherSearchState createState() => _TeacherSearchState();
}

class _TeacherSearchState extends State<TeacherSearch> {
  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController());

  @override
  void dispose() {
    teacher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
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
            padding: const EdgeInsets.only(left: 24, top: 12),
            child: input("강사", teacher),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                child: branchDropdown(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(96, 128, 104, 100),
                  ),
                  onPressed: branch.branchName == null
                      ? () {
                          showErrorMessage(context, "필수 입력값을 확인하세요!");
                        }
                      : () async {
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
