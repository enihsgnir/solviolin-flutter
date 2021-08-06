import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/widget/indicator.dart';
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
                        height: 135.h,
                        child: PageView.builder(
                          controller: PageController(),
                          physics: ClampingScrollPhysics(),
                          onPageChanged: (page) {
                            controller.updateCurrentPage(page);
                          },
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(top: 16.h),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    color: Colors.white, fontSize: 28.sp),
                                child: Column(
                                  children: [
                                    Text(
                                      "${reservations[index].teacherID} / ${reservations[index].branchName}",
                                    ),
                                    Text(
                                      "${dateTimeToString(reservations[index].startDate)} " +
                                          "~ ${dateTimeToTimeString(reservations[index].endDate)}",
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
                    margin: const EdgeInsets.all(8),
                    color: Colors.grey,
                    height: 0.5,
                  ),
                ],
              );
      },
    );
  }
}
