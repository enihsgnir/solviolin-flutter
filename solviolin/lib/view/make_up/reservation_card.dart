import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/dialog.dart';
import 'package:solviolin/widget/single.dart';
import 'package:solviolin/widget/swipeable_list.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationCard extends StatefulWidget {
  const ReservationCard({Key? key}) : super(key: key);

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
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

        return reservations.isEmpty
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
                              Text(reservation.toString()),
                              Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 12.r),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (reservation.startDate
                                        .isBefore(DateTime.now())) {
                                      await showError("지난 수업은 취소할 수 없습니다.");
                                    } else if (reservation.startDate.isAfter(
                                        controller.currentTerm[1].termEnd)) {
                                      await showError(
                                          "다음 학기의 수업 취소는 해당 학기에 가능합니다.");
                                    } else {
                                      await _showCancel(reservation);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: symbolColor),
                                  child: Text("취소", style: contentStyle),
                                ),
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

  Future _showCancel(Reservation reservation) {
    return showMyModal(
      context: context,
      title: formatDateTimeRange(reservation.startDate, reservation.endDate),
      message: "수업을 취소 하시겠습니까?",
      child: "수업 취소",
      isDestructiveAction: true,
      onPressed: () => showLoading(() async {
        try {
          await _client.cancel(reservation.id);

          await _data.getInitialData();
          await _data.getSelectedDayData(_data.selectedDay);
          await _data.getChangedPageData(_data.focusedDay);
          await _data.getReservedHistoryData();

          Get.back();

          await showMySnackbar(message: "수업 취소에 성공했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
    );
  }
}
