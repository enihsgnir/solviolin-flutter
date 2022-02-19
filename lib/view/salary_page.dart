import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      controller: search.expandable,
      contents: [
        branchDropdown("/search/salary", true),
        termDropdown("/search/salary", true),
        myTextInput(
          "주간시급",
          search.edit1,
          isMandatory: true,
          keyboardType: TextInputType.number,
        ),
        Row(
          children: [
            myTextInput(
              "야간시급",
              search.edit2,
              isMandatory: true,
              keyboardType: TextInputType.number,
            ),
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

                  search.isSearched = true;
                  search.expandable.expanded = false;

                  if (_data.salaries.isEmpty) {
                    await showMySnackbar(
                      title: "알림",
                      message: "검색 조건에 해당하는 목록이 없습니다.",
                    );
                  }
                } catch (e) {
                  showError(e);
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
          itemCount: _data.salaries.length,
          itemBuilder: (context, index) {
            return myNormalCard(
              children: [
                Text(_data.salaries[index].toString()),
              ],
            );
          },
        );
      },
    );
  }
}
