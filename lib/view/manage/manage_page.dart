import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/view/manage/history_reserved.dart';
import 'package:solviolin/widget/item_list.dart';
import 'package:solviolin/widget/single.dart';
import 'package:solviolin/widget/swipeable_list.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return Scaffold(
      appBar: myAppBar("나의 예약"),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            return Column(
              children: [
                SwipeableList(
                  itemCount: controller.regularSchedules.length,
                  itemBuilder: (context, index) {
                    var regular = controller.regularSchedules[index];

                    return mySwipeableCard(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 24.r),
                          width: double.infinity,
                          child: const Text("나의 수업"),
                        ),
                      ]..add(regular.dow != -1
                          ? Text(
                              regular.toString(),
                              textAlign: TextAlign.center,
                            )
                          : Text("\nWelcome to SOLVIOLIN :)")),
                    );
                  },
                ),
                myDivider(),
                TabBar(
                  controller: tabController,
                  tabs: ["지난 달", "이번 달", "변경 내역"]
                      .map((e) => Tab(
                            child: Text(e, style: TextStyle(fontSize: 28.r)),
                          ))
                      .toList(),
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
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    child: Icon(
                      CupertinoIcons.text_badge_xmark,
                      size: 48.r,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "변경내역을 조회할 수 없습니다.",
                    style: TextStyle(color: Colors.red, fontSize: 22.r),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: controller.changes.length,
                itemBuilder: (context, index) {
                  return myNormalCard(
                    children: [
                      Text(
                        controller.changes[index].toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}
