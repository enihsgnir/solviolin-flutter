import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class SalarySearch extends StatefulWidget {
  const SalarySearch({Key? key}) : super(key: key);

  @override
  _SalarySearchState createState() => _SalarySearchState();
}

class _SalarySearchState extends State<SalarySearch> {
  Client _client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  BranchController branch = Get.put(BranchController(), tag: "Salary");
  TermController term = Get.put(TermController());
  TextEditingController day = TextEditingController();
  TextEditingController night = TextEditingController();

  @override
  void dispose() {
    day.dispose();
    night.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mySearch(
      contents: [
        branchDropdown("Salary", "지점을 선택하세요!"),
        termDropdown("학기를 선택하세요!"),
        textInput("주간시급", day, "주간시급을 입력하세요!"),
        Row(
          children: [
            textInput("야간시급", night, "야간시급을 입력하세요!"),
            myActionButton(
              onPressed: () async {
                try {
                  _controller.updateSalaries(await _client.getSalaries(
                    branchName: branch.branchName!,
                    termID: term.termID!,
                    dayTimeCost: int.parse(day.text),
                    nightTimeCost: int.parse(night.text),
                  ));
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
