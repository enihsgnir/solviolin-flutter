import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/search.dart';

class LedgerSearch extends StatefulWidget {
  const LedgerSearch({Key? key}) : super(key: key);

  @override
  _LedgerSearchState createState() => _LedgerSearchState();
}

class _LedgerSearchState extends State<LedgerSearch> {
  var _client = Get.find<Client>();
  var _controller = Get.find<DataController>();

  var branch = Get.put(BranchController());
  var user = TextEditingController();
  var term = Get.put(TermController());

  @override
  void dispose() {
    user.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mySearch(
      contents: [
        branchDropdown(null, "지점을 선택하세요!"),
        Row(
          children: [
            myTextInput("수강생", user, "이름을 입력하세요!"),
            myActionButton(
              onPressed: () async {
                try {
                  _controller.updateTotalLedger(await _client.getTotalLedger(
                    branchName: branch.branchName!,
                    termID: term.termID!,
                  ));

                  _showTotal();
                } catch (e) {
                  showError(e.toString());
                }
              },
              action: "합계",
            ),
          ],
        ),
        Row(
          children: [
            termDropdown("학기를 선택하세요!"),
            myActionButton(
              onPressed: () async {
                try {
                  await getLedgersData(
                    branchName: branch.branchName!,
                    termID: term.termID!,
                    userID: user.text,
                  );
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

  Future _showTotal() {
    return showMyDialog(
      context: context,
      title: "총 매출",
      contents: [
        Text(
          _controller.totalLeger,
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ],
      onPressed: Get.back,
    );
  }
}
