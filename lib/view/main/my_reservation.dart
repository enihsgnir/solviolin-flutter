import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/view/main/indicator.dart';
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
        List<Reservation> reservations = [
          for (Reservation reservation in controller.myValidReservations)
            if (isSameDay(reservation.startDate, controller.selectedDay))
              reservation
        ];

        return reservations.length == 0
            ? Container()
            : Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 135.r,
                        child: PageView.builder(
                          controller: PageController(),
                          physics: ClampingScrollPhysics(),
                          onPageChanged: (page) {
                            controller.updateCurrentPage(page);
                          },
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            Reservation reservation = reservations[index];

                            return Container(
                              padding: EdgeInsets.only(top: 16.r),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 8.r),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.r,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "${reservation.teacherID} / ${reservation.branchName}",
                                    ),
                                    Text(
                                      DateFormat("yy/MM/dd HH:mm")
                                              .format(reservation.startDate) +
                                          " ~ " +
                                          DateFormat("HH:mm")
                                              .format(reservation.endDate),
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
                                reservations.length,
                                (index) => index == controller.currentPage
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
                    height: 0.5,
                  ),
                ],
              );
      },
    );
  }
}
