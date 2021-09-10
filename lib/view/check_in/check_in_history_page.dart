import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/dropdown.dart';
import 'package:solviolin_admin/widget/item_list.dart';
import 'package:solviolin_admin/widget/picker.dart';
import 'package:solviolin_admin/widget/search.dart';
import 'package:solviolin_admin/widget/single.dart';

class CheckInHistoryPage extends StatefulWidget {
  const CheckInHistoryPage({Key? key}) : super(key: key);

  @override
  _CheckInHistoryPageState createState() => _CheckInHistoryPageState();
}

class _CheckInHistoryPageState extends State<CheckInHistoryPage> {
  var _client = Get.find<Client>();
  var _controller = Get.find<DataController>();

  var search = Get.put(CacheController(), tag: "/search");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          "체크인 이력"), //TODO: get history data or implement with future builder?
      body: SafeArea(
        child: Column(
          children: [
            _checkInHistorySearch(),
            myDivider(),
            Expanded(
              child: _checkInHistoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkInHistorySearch() {
    return mySearch(
      contents: [
        branchDropdown("/search", "지점을 선택하세요!"),
        pickDate(
          context: context,
          item: "시작일",
          tag: "/search",
          index: 0,
        ),
        Row(
          children: [
            pickDate(
              context: context,
              item: "종료일",
              tag: "/search",
              index: 1,
            ),
            myActionButton(
              context: context,
              onPressed: () async {
                try {
                  _controller
                      .updateCheckInHistories(await _client.getCheckInHistories(
                    branchName: search.branchName!,
                    startDate: search.dateTime[0],
                    endDate: search.dateTime[1],
                  ));
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

  Widget _checkInHistoryList() {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.checkInHistories.length,
          itemBuilder: (context, index) {
            var checkIn = controller.checkInHistories[index];

            return myNormalCard(
              children: [
                Text("번호: ${checkIn.id}"),
                Text(checkIn.userID + " / " + checkIn.branchName),
                Text("체크인 시각: " +
                    DateFormat("yy/MM/dd HH:mm").format(checkIn.createdAt)),
              ],
            );
          },
        );
      },
    );
  }
}
