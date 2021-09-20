import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
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
    return widget.reservations.length == 0
        ? DefaultTextStyle(
            style: TextStyle(color: Colors.red, fontSize: 20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("예약내역을 조회할 수 없습니다."),
              ],
            ),
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
                              : await _showModalCancel(context, reservation);
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
                                  : await _showModalExtend(
                                      context, reservation);
                    },
                    borderLeft: true,
                  ),
                ],
                children: [
                  Text(
                    "${reservation.teacherID} / ${reservation.branchName}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.r,
                      decoration: reservation.bookingStatus.abs() == 2
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(
                    DateFormat("yy/MM/dd HH:mm").format(reservation.startDate) +
                        " ~ " +
                        DateFormat("HH:mm").format(reservation.endDate),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.r,
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
                      _statusToString(reservation.bookingStatus),
                      style: TextStyle(color: Colors.red, fontSize: 20.r),
                    ),
                  ),
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
            DateFormat("yy/MM/dd HH:mm").format(reservation.startDate) +
                " ~ " +
                DateFormat("HH:mm").format(reservation.endDate),
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

  Future _showModalExtend(BuildContext context, Reservation reservation) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            DateFormat("yy/MM/dd HH:mm").format(reservation.startDate) +
                " ~ " +
                DateFormat("HH:mm").format(
                    reservation.endDate.add(const Duration(minutes: 15))),
            style: TextStyle(fontSize: 24.r),
          ),
          message: Text("수업을 15분 연장 하시겠습니까?", style: TextStyle(fontSize: 24.r)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => showLoading(() async {
                try {
                  await _client.extendReservation(reservation.id);

                  await getUserBasedData();
                  await getSelectedDayData(_data.selectedDay);
                  await getChangedPageData(_data.focusedDay);
                  await getReservedHistoryData();

                  Get.back();

                  await showMySnackbar(
                    message: "수업 연장에 성공했습니다.",
                  );
                } catch (e) {
                  showError(e);
                }
              }),
              child: Text("수업 연장", style: TextStyle(fontSize: 24.r)),
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

String _statusToString(int bookingStatus) {
  Map<int, String> status = {
    0: "정규",
    1: "보강",
    2: "취소",
    3: "연장",
    -1: "보강(관리자)",
    -2: "취소(관리자)",
    -3: "연장(관리자)",
  };

  return status[bookingStatus]!;
}
