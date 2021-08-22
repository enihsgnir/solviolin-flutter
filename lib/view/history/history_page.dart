import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/view/history/changed_reservation.dart';
import 'package:solviolin/view/history/history_reserved.dart';
import 'package:solviolin/view/main/indicator.dart';
import 'package:solviolin/widget/single_reusable.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return Scaffold(
      appBar: appBar("내 예약"),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 175.r,
                      child: PageView.builder(
                        controller: PageController(),
                        physics: ClampingScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        itemCount: controller.regularSchedules.length,
                        itemBuilder: (context, index) {
                          RegularSchedule regular =
                              controller.regularSchedules[index];

                          return DefaultTextStyle(
                            style: TextStyle(fontSize: 28.r),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              margin: EdgeInsets.all(8.r),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.fromLTRB(24.r, 12.r, 0, 0),
                                    width: double.infinity,
                                    child: const Text("내 수업"),
                                  ),
                                  Text(
                                    regular.teacherID +
                                        " / ${regular.branchName}",
                                  ),
                                  Text(
                                    "${dowToString(regular.dow)}" +
                                        " / ${timeToString(regular.startTime)}" +
                                        " ~ ${timeToString(regular.endTime)}",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16.r),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              controller.regularSchedules.length,
                              (index) => index == currentPage
                                  ? indicator(isActive: true)
                                  : indicator(isActive: false),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(8.r),
                  color: Colors.grey,
                  height: 0.5.r,
                ),
                TabBar(
                  controller: tabController,
                  enableFeedback: false,
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
                Container(
                  margin: EdgeInsets.all(8.r),
                  color: Colors.grey,
                  height: 0.5.r,
                ),
                Container(
                  height: 1152.r,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4.r),
                        child: HistoryReserved(isThisMonth: false),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.r),
                        child: HistoryReserved(isThisMonth: true),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.r),
                        child: ChangedReservation(),
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
