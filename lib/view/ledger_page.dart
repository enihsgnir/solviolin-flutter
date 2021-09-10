import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({Key? key}) : super(key: key);

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  var _client = Get.find<Client>();
  var _controller = Get.find<DataController>();

  var search = Get.put(CacheController(), tag: "/search");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: myAppBar("매출"),
        body: SafeArea(
          child: Column(
            children: [
              _ledgerSearch(),
              myDivider(),
              Expanded(
                child: _ledgerList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ledgerSearch() {
    return mySearch(
      contents: [
        branchDropdown("/search", "지점을 선택하세요!"),
        Row(
          children: [
            myTextInput("수강생", search.edit1, "이름을 입력하세요!"),
            myActionButton(
              context: context,
              onPressed: () async {
                try {
                  showLoading();
                  _controller.totalLeger = await _client.getTotalLedger(
                    branchName: search.branchName!,
                    termID: search.termID!,
                  );
                  Get.back();

                  _showTotal();
                } catch (e) {
                  Get.back(); //TODO: manage showLoading()
                  showError(e.toString());
                }
              },
              action: "합계",
            ),
          ],
        ),
        Row(
          children: [
            termDropdown("/search", "학기를 선택하세요!"),
            myActionButton(
              context: context,
              onPressed: () async {
                try {
                  await getLedgersData(
                    branchName: search.branchName!,
                    termID: search.termID!,
                    userID: textEdit(search.edit1)!,
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
        Text(_controller.totalLeger),
      ],
      onPressed: Get.back,
    );
  }

  Widget _ledgerList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.ledgers.length,
          itemBuilder: (context, index) {
            var ledger = controller.ledgers[index];

            return myNormalCard(
              children: [
                Text("${ledger.userID} / ${ledger.branchName}"),
                Text(NumberFormat("#,###원").format(ledger.amount)),
                Text("결제일자: " +
                    DateFormat("yy/MM/dd HH:mm").format(ledger.paidAt)),
              ],
            );
          },
        );
      },
    );
  }
}
