import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
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
        resizeToAvoidBottomInset: false,
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
      controller: search.expandable,
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
                      ? showError("합계 조회 시 지점/학기는 필수 입력 항목입니다.")
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
                  await _data.getLedgersData(
                    branchName: search.branchName,
                    termID: search.termID,
                    userID: textEdit(search.edit1),
                  );

                  search.isSearched = true;
                  search.expandable.expanded = false;

                  if (_data.ledgers.isEmpty) {
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
        myTextInput("금액", search.edit2, keyboardType: TextInputType.number),
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
        return _data.ledgers.isEmpty
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                textAlign: TextAlign.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "검색란에 값을 미리 지정해두면 우측 하단의" +
                          "\n버튼을 통해 연결되는 원비납부 화면에서" +
                          "\n자동으로 연동됩니다." +
                          "\n\n합계 조회 시 지점/학기는 필수 입력 항목입니다." +
                          "\n\n금액은 매출 목록 검색 조건에 해당하지 않습니다.",
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _data.ledgers.length,
                itemBuilder: (context, index) {
                  var ledger = _data.ledgers[index];

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

                              await _data.getLedgersData(
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
                      Text(ledger.toString()),
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
        myTextInput("수강생", expend.edit1, isMandatory: true),
        branchDropdown("/expend", true),
        termDropdown("/expend", true),
        myTextInput(
          "금액",
          expend.edit2,
          isMandatory: true,
          keyboardType: TextInputType.number,
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.registerLedger(
            userID: textEdit(expend.edit1)!,
            amount: intEdit(expend.edit2)!,
            termID: expend.termID!,
            branchName: expend.branchName!,
          );

          await _data.getLedgersData(
            branchName: search.branchName,
            termID: search.termID,
            userID: textEdit(search.edit1),
          );

          Get.back();

          await showMySnackbar(message: "원비 납부 내역을 생성했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
      isScrollable: true,
    );
  }
}
