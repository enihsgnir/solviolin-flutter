import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';

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
    Get.find<DataController>();
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
        child: GetBuilder<DataController>(
          builder: (controller) {
            return ListView(
              children: [
                Container(
                  height: 100,
                  color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("내 수업"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(dowToString(controller.regularSchedules[0].dow)),
                          // Text(
                          //     "${timeToString(regularScheduleTest.startTime)}"
                          //     "~${timeToString(regularScheduleTest.endTime)}"),
                          Text(controller.regularSchedules[0].branchName),
                        ],
                      ),
                      Text(controller.regularSchedules[0].teacherID),
                    ],
                  ),
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
                                //     "${dateToString(regularScheduleTest.startTime)}"
                                //     " ${timeToString(regularScheduleTest.startTime)}"
                                //     "~${timeToString(regularScheduleTest.endTime)}",
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
            );
          },
        ),
      ),
    );
  }
}
