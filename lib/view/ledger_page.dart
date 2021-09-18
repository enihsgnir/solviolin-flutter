import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
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
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/ledger");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
        branchDropdown("/search/ledger"),
        Row(
          children: [
            myTextInput("수강생", search.edit1),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  _data.totalLeger = await _client.getTotalLedger(
                    branchName: search.branchName!,
                    termID: search.termID!,
                  );

                  _showTotal();
                } catch (e) {
                  e.toString() == "Null check operator used on a null value"
                      ? showError("지점/학기는 필수 입력 항목입니다")
                      : showError(e.toString());
                }
              }),
              action: "합계",
            ),
          ],
        ),
        Row(
          children: [
            termDropdown("/search/ledger"),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  await getLedgersData(
                    branchName: search.branchName,
                    termID: search.termID,
                    userID: textEdit(search.edit1),
                  );

                  if (_data.ledgers.length == 0) {
                    await showMySnackbar(
                      title: "알림",
                      message: "검색 조건에 해당하는 목록이 없습니다.",
                    );
                  }
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

  Future _showTotal() {
    return showMyDialog(
      title: "총 매출",
      contents: [
        Text(_data.totalLeger),
      ],
      onPressed: Get.back,
    );
  }

  Widget _ledgerList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.ledgers.length == 0
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("합계 조회 시 지점/학기는"),
                    Text("필수 입력 항목입니다"),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: controller.ledgers.length,
                itemBuilder: (context, index) {
                  var ledger = controller.ledgers[index];

                  return mySlidableCard(
                    slideActions: [
                      mySlideAction(
                        context: context,
                        icon: CupertinoIcons.delete,
                        item: "삭제",
                        onTap: () => showMyDialog(
                          title: "매출 내역 삭제",
                          contents: [
                            Text("정말 삭제하시겠습니까?"),
                          ],
                          onPressed: () => showLoading(() async {
                            try {
                              await _client.deleteLedger(ledger.id);

                              await getLedgersData(
                                branchName: search.branchName,
                                termID: search.termID,
                                userID: textEdit(search.edit1),
                              );

                              Get.back();

                              await showMySnackbar(
                                message: "매출 내역 삭제에 성공했습니다.",
                              );
                            } catch (e) {
                              showError(e.toString());
                            }
                          }),
                        ),
                      ),
                    ],
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
