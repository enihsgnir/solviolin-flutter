import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/dialog.dart';
import 'package:solviolin/widget/single.dart';
import 'package:solviolin/widget/swipeable_list.dart';
import 'package:table_calendar/table_calendar.dart';

class MyReservation extends StatefulWidget {
  const MyReservation({Key? key}) : super(key: key);

  @override
  _MyReservationState createState() => _MyReservationState();
}

class _MyReservationState extends State<MyReservation> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
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
                  SwipeableList(
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      var reservation = reservations[index];

                      return mySwipeableCard(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.topCenter,
                            children: [
                              Text(
                                reservation.toString(),
                                textAlign: TextAlign.center,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 16.r),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        reservation.startDate
                                                .isBefore(DateTime.now())
                                            ? await showError(
                                                "지난 수업은 취소할 수 없습니다.")
                                            : await _showModalCancel(
                                                context, reservation);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: symbolColor),
                                      child: Text("취소", style: contentStyle),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  Future _showModalCancel(BuildContext context, Reservation reservation) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            formatDateTimeRange(reservation.startDate, reservation.endDate),
            style: TextStyle(fontSize: 24.r),
          ),
          message: Text("수업을 취소 하시겠습니까?", style: TextStyle(fontSize: 24.r)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => showLoading(() async {
                try {
                  await _client.cancelReservation(reservation.id);

                  await getUserBasedData();
                  await getSelectedDayData(_data.selectedDay);
                  await getChangedPageData(_data.focusedDay);
                  await getReservedHistoryData();

                  Get.back();

                  await showMySnackbar(
                    message: "수업 취소에 성공했습니다.",
                  );
                } catch (e) {
                  showError(e);
                }
              }),
              isDestructiveAction: true,
              child: Text("수업 취소", style: TextStyle(fontSize: 24.r)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: Get.back,
            isDefaultAction: true,
            child: Text("닫기", style: TextStyle(fontSize: 24.r)),
          ),
        );
      },
    );
  }
}
