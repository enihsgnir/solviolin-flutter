import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  TextEditingController id = TextEditingController();
  BranchController branch = Get.put(BranchController());
  CheckController isPaid = Get.put(CheckController(), tag: "isPaid");
  CheckController status = Get.put(CheckController(), tag: "status");

  SearchController search = Get.find<SearchController>(tag: "User");

  @override
  void dispose() {
    id.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 24.r),
                child: input("이름", id),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.r),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                  ),
                  onPressed: () async {
                    await saveUsersData(
                      branchName: branch.branchName,
                      userID: id.text == "" ? null : id.text,
                      isPaid: isPaid.result,
                      status: status.result,
                    );

                    Get.snackbar(
                      "",
                      "",
                      titleText: Text(
                        "유저 정보 목록 저장",
                        style: TextStyle(color: Colors.white, fontSize: 24.r),
                      ),
                      messageText: Text(
                        "storage/emulated/0/Download/SolViolin/users_list.json",
                        style: TextStyle(color: Colors.white, fontSize: 20.r),
                      ),
                    );
                  },
                  child: Text("저장", style: TextStyle(fontSize: 20.r)),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: branchDropdown(),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: check(
              tag: "isPaid",
              item: "결제 여부",
              trueName: "완료",
              falseName: "미완료",
            ),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
                child: check(
                  tag: "status",
                  item: "등록 여부",
                  trueName: "등록",
                  falseName: "미등록",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 36.r),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                  ),
                  onPressed: () async {
                    try {
                      search.text1 = branch.branchName;
                      search.text2 = id.text == "" ? null : id.text;
                      search.number1 = isPaid.result;
                      search.number2 = status.result;

                      await getUsersData(
                        branchName: search.text1,
                        userID: search.text2,
                        isPaid: search.number1,
                        status: search.number2,
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
