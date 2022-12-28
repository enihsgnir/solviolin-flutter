import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/dialog.dart';
import 'package:solviolin/widget/item_list.dart';

class HistoryReserved extends StatefulWidget {
  final List<Reservation> reservations;

  const HistoryReserved(
    this.reservations, {
    Key? key,
  }) : super(key: key);

  @override
  _HistoryReservedState createState() => _HistoryReservedState();
}

class _HistoryReservedState extends State<HistoryReserved> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return widget.reservations.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                child: Icon(
                  CupertinoIcons.text_badge_xmark,
                  size: 48.r,
                  color: Colors.red,
                ),
              ),
              Text(
                "예약내역을 조회할 수 없습니다.",
                style: TextStyle(color: Colors.red, fontSize: 22.r),
              ),
            ],
          )
        : ListView.builder(
            itemCount: widget.reservations.length,
            itemBuilder: (context, index) {
              var reservation = widget.reservations[index];

              return mySlidableCard(
                slideActions: [
                  mySlideAction(
                    context: context,
                    icon: CupertinoIcons.delete_left,
                    item: "취소",
                    onTap: () async {
                      reservation.startDate.isBefore(DateTime.now())
                          ? await showError("지난 수업은 취소할 수 없습니다.")
                          : reservation.bookingStatus.abs() == 2
                              ? await showError("이미 취소된 수업입니다.")
                              : await _showCancel(reservation);
                    },
                    borderRight: true,
                  ),
                  mySlideAction(
                    context: context,
                    icon: Icons.more_time,
                    item: "연장",
                    onTap: () async {
                      reservation.startDate.isBefore(DateTime.now())
                          ? await showError("지난 수업은 연장할 수 없습니다.")
                          : reservation.bookingStatus.abs() == 3
                              ? await showError("이미 연장된 수업입니다.")
                              : reservation.bookingStatus.abs() == 2
                                  ? await showError("취소된 수업은 연장할 수 없습니다.")
                                  : await _showExtend(reservation);
                    },
                    borderLeft: true,
                  ),
                ],
                children: [
                  Text(
                    reservation.toString(),
                    style: TextStyle(
                      decoration: reservation.bookingStatus.abs() == 2
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 24.r),
                    width: double.infinity,
                    child: Text(
                      reservation.statusToString,
                      style: TextStyle(color: Colors.red, fontSize: 20.r),
                    ),
                  ),
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

  Future _showExtend(Reservation reservation) {
    return showMyModal(
      context: context,
      title: formatDateTimeRange(reservation.startDate,
          reservation.endDate.add(const Duration(minutes: 15))),
      message: "수업을 15분 연장 하시겠습니까?",
      child: "수업 연장",
      onPressed: () => showLoading(() async {
        try {
          await _client.extend(reservation.id);

          await _data.getInitialData();
          await _data.getSelectedDayData(_data.selectedDay);
          await _data.getChangedPageData(_data.focusedDay);
          await _data.getReservedHistoryData();

          Get.back();

          await showMySnackbar(message: "수업 연장에 성공했습니다.");
        } catch (e) {
          showError(e);
        }
      }),
    );
  }
}
