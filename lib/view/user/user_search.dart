import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  TextEditingController id = TextEditingController();
  BranchController branch = Get.put(BranchController());
  CheckController _isPaid = Get.put(CheckController(), tag: "isPaid");
  CheckController _status = Get.put(CheckController(), tag: "status");

  @override
  void dispose() {
    id.dispose();
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
            child: input("이름", id),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(24, 12, 0, 0),
            child: branchDropdown(),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(24, 12, 0, 0),
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
                padding: const EdgeInsets.fromLTRB(24, 12, 0, 0),
                child: check(
                  tag: "status",
                  item: "등록 여부",
                  trueName: "등록",
                  falseName: "미등록",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(96, 128, 104, 100),
                  ),
                  onPressed: () async {
                    try {
                      String userID = id.text;
                      await getUsersData(
                        branchName: branch.branchName,
                        userID: userID == "" ? null : userID,
                        isPaid: _isPaid.result,
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
