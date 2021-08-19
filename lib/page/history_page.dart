import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/widget/changed_reservation.dart';
import 'package:solviolin/widget/history_reserved.dart';
import 'package:solviolin/widget/indicator.dart';

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.chevron_left, size: 28.r),
        ),
        title: Text("내 예약", style: TextStyle(fontSize: 28.sp)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            List<RegularSchedule> regulars = controller.regularSchedules;

            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 175.h,
                      child: PageView.builder(
                        controller: PageController(),
                        physics: ClampingScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                        },
                        itemCount: regulars.length,
                        itemBuilder: (context, index) {
                          return DefaultTextStyle(
                            style: TextStyle(fontSize: 28.sp),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(
                                      left: 24,
                                      top: 12,
                                    ),
                                    width: double.infinity,
                                    child: const Text("내 수업"),
                                  ),
                                  Text(
                                    regulars[index].teacherID +
                                        " / ${regulars[index].branchName}",
                                  ),
                                  Text(
                                    "${dowToString(regulars[index].dow)}" +
                                        " / ${timeToString(regulars[index].startTime)}" +
                                        " ~ ${timeToString(regulars[index].endTime)}",
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
                          margin: EdgeInsets.only(bottom: 16.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(
                              regulars.length,
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
                  margin: EdgeInsets.all(8),
                  color: Colors.grey,
                  height: 0.5,
                ),
                TabBar(
                  controller: tabController,
                  enableFeedback: false,
                  tabs: [
                    Tab(
                      child: Text("지난 달", style: TextStyle(fontSize: 28.sp)),
                    ),
                    Tab(
                      child: Text("이번 달", style: TextStyle(fontSize: 28.sp)),
                    ),
                    Tab(
                      child: Text("변경내역", style: TextStyle(fontSize: 28.sp)),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  color: Colors.grey,
                  height: 0.5,
                ),
                Container(
                  height: 1.sh,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            HistoryReserved(controller.lastMonthReservations),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            HistoryReserved(controller.thisMonthReservations),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
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
