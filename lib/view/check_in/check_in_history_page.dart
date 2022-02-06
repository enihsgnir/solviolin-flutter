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
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/check-in");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("체크인 이력"),
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
    if (!search.isSearched) {
      var today = DateTime.now();
      search.date[0] = DateTime(today.year, today.month, today.day);
      search.date[1] = DateTime(today.year, today.month, today.day);
    }

    return mySearch(
      contents: [
        branchDropdown("/search/check-in", true),
        pickDate(
          context: context,
          item: "부터",
          tag: "/search/check-in",
          index: 0,
        ),
        Row(
          children: [
            pickDate(
              context: context,
              item: "까지",
              tag: "/search/check-in",
              index: 1,
            ),
            myActionButton(
              context: context,
              onPressed: () => showLoading(() async {
                try {
                  _data.checkInHistories = await _client.getCheckInHistories(
                    branchName: search.branchName!,
                    startDate: search.date[0],
                    endDate: search.date[1]?.add(
                        const Duration(hours: 23, minutes: 59, seconds: 59)),
                  );
                  _data.update();

                  search.isSearched = true;

                  if (_data.checkInHistories.length == 0) {
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
