import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/widget/history_reserved.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.chevron_left, size: 28),
        ),
        title: Text("내 예약", style: TextStyle(fontSize: 28)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            List<RegularSchedule> regularSchedules =
                controller.regularSchedules;

            return ListView(
              children: [
                DefaultTextStyle(
                  style: TextStyle(fontSize: 30),
                  child: Container(
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("내 수업"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(dowToString(regularSchedules[0].dow)),
                            Text(timeToString(regularSchedules[0].startTime)),
                            Text(timeToString(regularSchedules[0].endTime)),
                            Text(regularSchedules[0].branchName),
                          ],
                        ),
                        Text(regularSchedules[0].teacherID),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  color: Colors.grey,
                  height: 0.5,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    tabs: [
                      Tab(
                          child: Text(
                        "지난 달",
                        style: TextStyle(fontSize: 28),
                      )),
                      Tab(
                          child: Text(
                        "이번 달",
                        style: TextStyle(fontSize: 28),
                      )),
                    ],
                    controller: tabController,
                    isScrollable: true,
                    enableFeedback: false,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      HistoryReserved(
                        reservations: controller.lastMonthReservations,
                      ),
                      HistoryReserved(
                        reservations: controller.thisMonthReservations,
                      ),
                    ],
                    controller: tabController,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
