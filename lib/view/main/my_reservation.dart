import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/widget/single.dart';
import 'package:solviolin/widget/swipeable_list.dart';
import 'package:table_calendar/table_calendar.dart';

class MyReservation extends StatefulWidget {
  const MyReservation({Key? key}) : super(key: key);

  @override
  _MyReservationState createState() => _MyReservationState();
}

class _MyReservationState extends State<MyReservation> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        var reservations = controller.myValidReservations
            .where((element) =>
                isSameDay(element.startDate, controller.selectedDay))
            .toList();

        return reservations.length == 0
            ? Container()
            : Column(
                children: [
                  swipeableList(
                    height: 150.r,
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      var reservation = reservations[index];

                      return mySwipeableCard(
                        children: [
                          Text(reservation.teacherID +
                              " / " +
                              reservation.branchName),
                          Text(DateFormat("yy/MM/dd HH:mm")
                                  .format(reservation.startDate) +
                              " ~ " +
                              DateFormat("HH:mm").format(reservation.endDate)),
                        ],
                      );
                    },
                  ),
                  myDivider(),
                ],
              );
      },
    );
  }
}
