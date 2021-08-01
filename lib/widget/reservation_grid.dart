import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/notification.dart';

class ReservationGrid extends StatefulWidget {
  const ReservationGrid({Key? key}) : super(key: key);

  @override
  _ReservationGridState createState() => _ReservationGridState();
}

class _ReservationGridState extends State<ReservationGrid> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return controller.availabaleTimes.length == 0
            ? Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: const Text(
                    "예약가능한 시간대가 없습니다!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22,
                    ),
                  ),
                ),
              )
            : GridView.count(
                padding: const EdgeInsets.all(8),
                childAspectRatio: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 16,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: 4,
                children: List<InkWell>.generate(
                  controller.availabaleTimes.length,
                  (index) => InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(96, 128, 104, 100),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "${dateTimeToTimeString(controller.availabaleTimes[index])}",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    onTap: () {
                      modalReserve(context, controller.availabaleTimes[index]);
                    },
                    enableFeedback: false,
                  ),
                ),
              );
      },
    );
  }
}
