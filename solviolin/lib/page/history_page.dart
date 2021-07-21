import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(RegularScheduleController());
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     icon: Icon(Icons.arrow_back_outlined),
      //   ),
      // ),
      body: SafeArea(
        child: ListView(
          children: [
            GetBuilder<RegularScheduleController>(
              builder: (controller) {
                return Container(
                  height: 100,
                  color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("내 수업"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_dowToString(controller.regularSchedule.dow)),
                          // Text(
                          //     "${DateFormat.Hm().format(regularScheduleTest.startTime)}"
                          //     "~${DateFormat.Hm().format(regularScheduleTest.endTime)}"),
                          Text(controller.regularSchedule.branchName),
                        ],
                      ),
                      Text(controller.regularSchedule.teacherID),
                    ],
                  ),
                );
              },
            ),
            Container(
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: "지난 달"),
                  Tab(text: "이번 달"),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(),
                  ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          border: Border(
                            left: BorderSide(
                              color: Colors.black45,
                            ),
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //     "${DateFormat.yMMMMd().format(regularScheduleTest.startTime)}"
                            //     " ${DateFormat.Hm().format(regularScheduleTest.startTime)}"
                            //     "~${DateFormat.Hm().format(regularScheduleTest.endTime)}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Text(regularScheduleTest.branchName),
                                // Text(regularScheduleTest.teacherID),
                              ],
                            ),
                            Text(
                              "(BookingStatus)",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    // itemCount: reservationListTest.length,
                    itemCount: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dowToString(int dow) {
    Map<int, String> dayData = {
      0: "일",
      1: "월",
      2: "화",
      3: "수",
      4: "목",
      5: "금",
      6: "토",
    };

    return dayData[dow]!;
  }

  // String _dateToString(DateTime dateTime) {
  //   return "";
  // }
}
