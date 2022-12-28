import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class CanceledPage extends StatefulWidget {
  const CanceledPage({Key? key}) : super(key: key);

  @override
  _CanceledPageState createState() => _CanceledPageState();
}

class _CanceledPageState extends State<CanceledPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/canceled");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: myAppBar("취소 내역"),
        body: SafeArea(
          child: Column(
            children: [
              _canceledSearch(),
              myDivider(),
              Expanded(
                child: _canceledList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _canceledSearch() {
    return mySearch(
      padding: EdgeInsets.symmetric(vertical: 16.r),
      contents: [
        Row(
          children: [
            myTextInput("강사", search.edit1, isMandatory: true),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  _data.canceledReservations = await _client
                      .getCanceledReservations(textEdit(search.edit1)!);
                  _data.update();

                  search.isSearched = true;

                  if (_data.canceledReservations.isEmpty) {
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

  Widget _canceledList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: _data.canceledReservations.length,
          itemBuilder: (context, index) {
            return myNormalCard(
              children: [
                Text(_data.canceledReservations[index].toString()),
              ],
            );
          },
        );
      },
    );
  }
}
