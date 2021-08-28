import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
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
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 24.r),
            child: branchDropdown("Salary", "지점을 선택하세요!"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: termDropdown("학기를 선택하세요!"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
            child: input("주간시급", day, "주간시급을 입력하세요!"),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(24.r, 6.r, 0, 0),
                child: input("야간시급", night, "야간시급을 입력하세요!"),
              ),
              Padding(
                padding: EdgeInsets.only(left: 36.r),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: symbolColor,
                  ),
                  onPressed: () async {
                    try {
                      _controller.updateSalaries(await _client.getSalaries(
                        branchName: branch.branchName!,
                        termID: term.termID!,
                        dayTimeCost: int.parse(day.text),
                        nightTimeCost: int.parse(night.text),
                      ));
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
