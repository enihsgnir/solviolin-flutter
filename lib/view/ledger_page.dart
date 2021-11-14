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
  var expend = Get.put(CacheController(), tag: "/expend");

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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, size: 36.r),
          onPressed: _showExpend,
        ),
      ),
    );
  }

  Widget _ledgerSearch() {
    return mySearch(
      contents: [
        myTextInput("수강생", search.edit1),
        Row(
          children: [
            branchDropdown("/search/ledger"),
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
                  e is CastError
                      ? showError("지점/학기는 필수 입력 항목입니다.")
                      : showError(e);
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

                  search.isSearched = true;

                  if (_data.ledgers.length == 0) {
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
        myTextInput("금액", search.edit2, false, TextInputType.number),
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
                textAlign: TextAlign.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("합계 조회 시 지점/학기는"),
                    Text("필수 입력 항목입니다."),
                    Text("\n검색란에 값을 미리 지정해두면"),
                    Text("우측 하단의 버튼을 통해 연결되는"),
                    Text("원비납부 화면에서 자동으로 연동됩니다."),
                    Text("('금액'은 검색 조건에 해당하지 않습니다.)"),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: controller.ledgers.length,
                itemBuilder: (context, index) {
                  var ledger = controller.ledgers[index];

                  var _termIndex = controller.terms
                      .indexWhere((element) => ledger.termID == element.id);
                  var _termString = _termIndex < 0
                      ? DateFormat("yy/MM/dd")
                              .format(controller.terms.last.termStart) +
                          " 이전"
                      : DateFormat("yy/MM/dd")
                              .format(controller.terms[_termIndex].termStart) +
                          " ~ " +
                          DateFormat("yy/MM/dd")
                              .format(controller.terms[_termIndex].termEnd);

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
                              showError(e);
                            }
                          }),
                        ),
                      ),
                    ],
                    children: [
                      Text("${ledger.userID} / ${ledger.branchName} / " +
                          NumberFormat("#,###원").format(ledger.amount)),
                      Text("학기: " + _termString),
                      Text("결제일자: " +
                          DateFormat("yy/MM/dd HH:mm").format(ledger.paidAt)),
                    ],
                  );
                },
              );
      },
    );
  }

  Future _showExpend() {
    FocusScope.of(context).requestFocus(FocusNode());
    expend.reset();
    expend.edit1.text = search.edit1.text;
    expend.branchName = search.branchName;
    expend.termID = search.termID;
    expend.edit2.text = search.edit2.text;

    return showMyDialog(
      title: "원비납부",
      contents: [
        myTextInput("수강생", expend.edit1, true),
        branchDropdown("/expend", true),
        termDropdown("/expend", true),
        myTextInput("금액", expend.edit2, true, TextInputType.number),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerLedger(
            userID: textEdit(expend.edit1)!,
            amount: intEdit(expend.edit2)!,
            termID: expend.termID!,
            branchName: expend.branchName!,
          );

          await getLedgersData(
            branchName: search.branchName,
            termID: search.termID,
            userID: textEdit(search.edit1),
          );

          Get.back();

          await showMySnackbar(
            message: "원비 납부 내역을 생성했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
      isScrollable: true,
    );
  }
}
