import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/regular_schedule.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/widget/reservation_history.dart';

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
      body: SafeArea(
        child: GetBuilder<DataController>(
          builder: (controller) {
            List<RegularSchedule> _regularSchedules =
                controller.regularSchedules;
            List<Reservation> _thisReservations =
                controller.myThisMonthReservations;
            List<Reservation> _lastReservations =
                controller.myLastMonthReservations;
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
                          Text(dowToString(_regularSchedules[0].dow)),
                          Text(timeToString(_regularSchedules[0].startTime)),
                          Text(timeToString(_regularSchedules[0].endTime)),
                          Text(_regularSchedules[0].branchName),
                        ],
                      ),
                      Text(_regularSchedules[0].teacherID),
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
                      ReservationHistory(reservations: _lastReservations),
                      ReservationHistory(reservations: _thisReservations),
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
