import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/view/history/history_reserved.dart';
import 'package:solviolin/widget/dialog.dart';
import 'package:solviolin/widget/item_list.dart';
import 'package:solviolin/widget/single.dart';
import 'package:solviolin/widget/swipeable_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  var _client = Get.find<Client>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return Scaffold(
      appBar: myAppBar(
        "내 예약",
        actions: [
          IconButton(
            onPressed: _showLogout,
            icon: Icon(Icons.logout_outlined, size: 28.r),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            return Column(
              children: [
                swipeableList(
                  height: 200.r,
                  itemCount: controller.regularSchedules.length,
                  itemBuilder: (context, index) {
                    var regular = controller.regularSchedules[index];

                    return mySwipeableCard(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 24.r),
                          width: double.infinity,
                          child: const Text("내 수업"),
                        ),
                        Text(regular.teacherID + " / ${regular.branchName}"),
                        Text("${dowToString(regular.dow)}" +
                            " / ${timeToString(regular.startTime)}" +
                            " ~ ${timeToString(regular.endTime)}"),
                      ],
                    );
                  },
                ),
                myDivider(),
                TabBar(
                  controller: tabController,
                  tabs: [
                    Tab(
                      child: Text("지난 달", style: TextStyle(fontSize: 28.r)),
                    ),
                    Tab(
                      child: Text("이번 달", style: TextStyle(fontSize: 28.r)),
                    ),
                    Tab(
                      child: Text("변경 내역", style: TextStyle(fontSize: 28.r)),
                    ),
                  ],
                ),
                myDivider(),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      HistoryReserved(controller.lastMonthReservations),
                      HistoryReserved(controller.thisMonthReservations),
                      _changedList(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _changedList() {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.changes.length == 0
            ? DefaultTextStyle(
                style: TextStyle(color: Colors.red, fontSize: 20.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("변경내역을 조회할 수 없습니다."),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: controller.changes.length,
                itemBuilder: (context, index) {
                  var change = controller.changes[index];

                  return myNormalCard(
                    children: [
                      Text("${change.teacherID} / ${change.branchName}"),
                      Text("변경 전: " +
                          DateFormat("yy/MM/dd HH:mm").format(change.fromDate)),
                      Text(change.toDate == null
                          ? "변경 사항이 없습니다."
                          : "변경 후: " +
                              DateFormat("yy/MM/dd HH:mm")
                                  .format(change.toDate!)),
                    ],
                  );
                },
              );
      },
    );
  }

  Future _showLogout() {
    return showMyDialog(
      contents: [
        Text("로그아웃 하시겠습니까?"),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.logout();
        } catch (_) {
        } finally {
          Get.offAllNamed("/login");

          await showMySnackbar(
            message: "안전하게 로그아웃 되었습니다.",
          );
        }
      }),
    );
  }
}
