import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({Key? key}) : super(key: key);

  @override
  _SalaryPageState createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  var _client = Get.find<Client>();
  var _controller = Get.find<DataController>();

  var search = Get.put(CacheController(), tag: "/search/salary");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar("급여 계산"),
        body: SafeArea(
          child: Column(
            children: [
              _salarySearch(),
              myDivider(),
              Expanded(
                child: _salaryList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _salarySearch() {
    return mySearch(
      contents: [
        branchDropdown("/search/salary", "지점을 선택하세요!"),
        termDropdown("/search/salary", "학기를 선택하세요!"),
        myTextInput("주간시급", search.edit1, "주간시급을 입력하세요!"),
        Row(
          children: [
            myTextInput("야간시급", search.edit2, "야간시급을 입력하세요!"),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  _controller.updateSalaries(await _client.getSalaries(
                    branchName: search.branchName!,
                    termID: search.termID!,
                    dayTimeCost: int.parse(textEdit(search.edit1)!),
                    nightTimeCost: int.parse(textEdit(search.edit2)!),
                  ));
                } catch (e) {
                  showError(e.toString());
                }
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _salaryList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.salaries.length,
          itemBuilder: (context, index) {
            var salary = controller.salaries[index];

            return myNormalCard(
              children: [
                Text(salary.teacherID),
                Text(
                    "주간근로시간: " + NumberFormat("#,###분").format(salary.dayTime)),
                Text("야간근로시간: " +
                    NumberFormat("#,###분").format(salary.nightTime)),
                Text("급여: " + NumberFormat("#,###원").format(salary.income)),
              ],
            );
          },
        );
      },
    );
  }
}
