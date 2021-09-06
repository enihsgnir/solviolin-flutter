import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/search.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  var id = TextEditingController();
  var branch = Get.put(BranchController());
  var isPaid = Get.put(CheckController(), tag: "isPaid");
  var type = Get.put(RadioController<UserType>(), tag: "Search");
  var status = Get.put(CheckController(), tag: "status");

  var search = Get.find<SearchController>(tag: "User");

  @override
  void dispose() {
    id.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mySearch(
      contents: [
        Row(
          children: [
            myTextInput("이름", id),
            myActionButton(
              onPressed: () async {
                try {
                  await saveUsersData(
                    branchName: branch.branchName,
                    userID: id.text == "" ? null : id.text,
                    isPaid: isPaid.result,
                    status: status.result,
                  );
                } catch (e) {
                  showError(e.toString());
                }
              },
              action: "저장",
            ),
          ],
        ),
        branchDropdown(),
        myCheckBox(
          tag: "isPaid",
          item: "결제 여부",
          trueName: "완료",
          falseName: "미완료",
        ),
        myRadio<UserType>(
          tag: "Search",
          item: "구분",
          names: ["수강생", "강사", "관리자"],
          values: [UserType.student, UserType.teacher, UserType.admin],
          groupValue: UserType.student,
        ),
        Row(
          children: [
            myCheckBox(
              tag: "status",
              item: "등록 여부",
              trueName: "등록",
              falseName: "미등록",
            ),
            myActionButton(
              onPressed: () async {
                try {
                  search.text1 = branch.branchName;
                  search.text2 = id.text == "" ? null : id.text;
                  search.number1 = isPaid.result;
                  search.number2 = type.type == UserType.student
                      ? 0
                      : type.type == UserType.teacher
                          ? 1
                          : 2;
                  search.number3 = status.result;

                  await getUsersData(
                    branchName: search.text1,
                    userID: search.text2,
                    isPaid: search.number1,
                    userType: search.number2,
                    status: search.number3,
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

enum UserType {
  student,
  teacher,
  admin,
}
