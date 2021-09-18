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
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/salary");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
        myTextInput("주간시급", search.edit1, "주간시급을 입력하세요!", TextInputType.number),
        Row(
          children: [
            myTextInput(
                "야간시급", search.edit2, "야간시급을 입력하세요!", TextInputType.number),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  _data.salaries = await _client.getSalaries(
                    branchName: search.branchName!,
                    termID: search.termID!,
                    dayTimeCost: intEdit(search.edit1)!,
                    nightTimeCost: intEdit(search.edit2)!,
                  );
                  _data.update();

                  if (_data.salaries.length == 0) {
                    await showMySnackbar(
                      title: "알림",
                      message: "검색 조건에 해당하는 목록이 없습니다.",
                    );
                  }
                } catch (e) {
                  showError(e.toString());
                  print(e.runtimeType);
                  // showError(TypeError().toString());
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
