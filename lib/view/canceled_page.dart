import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class CancelPage extends StatefulWidget {
  const CancelPage({Key? key}) : super(key: key);

  @override
  _CancelPageState createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  var search = Get.put(CacheController(), tag: "/search");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            myTextInput("강사", search.edit1, "강사명을 입력하세요!"),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  await getCanceledData(textEdit(search.edit1)!);
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

  Widget _canceledList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.canceledReservations.length,
          itemBuilder: (context, index) {
            var canceled = controller.canceledReservations[index];

            return myNormalCard(
              children: [
                Text(
                    "${canceled.teacherID} / ${canceled.userID} / ${canceled.branchName}"),
                Text(DateFormat("yy/MM/dd HH:mm").format(canceled.startDate) +
                    " ~ " +
                    DateFormat("HH:mm").format(canceled.endDate)),
                Text(canceled.toID.length == 0
                    ? "보강 미예약"
                    : "보강 ID: " + canceled.toID.toString()),
              ],
            );
          },
        );
      },
    );
  }
}
