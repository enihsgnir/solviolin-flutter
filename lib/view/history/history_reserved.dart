import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/single_reusable.dart';

class HistoryReserved extends StatefulWidget {
  final bool isThisMonth;

  const HistoryReserved({
    Key? key,
    required this.isThisMonth,
  }) : super(key: key);

  @override
  _HistoryReservedState createState() => _HistoryReservedState();
}

class _HistoryReservedState extends State<HistoryReserved> {
  Client _client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: widget.isThisMonth
              ? controller.thisMonthReservations.length
              : controller.lastMonthReservations.length,
          itemBuilder: (context, index) {
            Reservation reservation = widget.isThisMonth
                ? controller.thisMonthReservations[index]
                : controller.lastMonthReservations[index];

            return Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: 1 / 5,
              secondaryActions: [
                SlideAction(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.delete_left, size: 48.r),
                                Text(
                                  "취소",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.r,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            reservation.bookingStatus.abs() == 2
                                ? showError(context, "이미 취소된 수업입니다.")
                                : await _showCancel(context, reservation);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.r),
                        color: Colors.white,
                        width: 0.25.r,
                      ),
                    ],
                  ),
                ),
                SlideAction(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.r),
                        color: Colors.white,
                        width: 0.25.r,
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.more_time, size: 48.r),
                                Text(
                                  "연장",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.r,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            reservation.bookingStatus.abs() == 3
                                ? showError(context, "이미 연장된 수업입니다.")
                                : await _showExtend(context, reservation);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 24.r),
                margin: EdgeInsets.fromLTRB(8.r, 4.r, 8.r, 4.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      DateFormat("yy/MM/dd HH:mm")
                              .format(reservation.startDate) +
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
                      padding: const EdgeInsets.only(right: 24),
                      width: double.infinity,
                      child: Text(
                        _statusToString(reservation.bookingStatus),
                        style: TextStyle(color: Colors.red, fontSize: 20.r),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future _showCancel(BuildContext context, Reservation reservation) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          DateFormat("yy/MM/dd HH:mm").format(reservation.startDate) +
              " ~ " +
              DateFormat("HH:mm").format(reservation.endDate),
          style: TextStyle(fontSize: 24.r),
        ),
        message: Text("수업을 취소 하시겠습니까?", style: TextStyle(fontSize: 24.r)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              try {
                await _client.cancelReservation(reservation.id);

                await getUserBasedData();
                await getSelectedDayData(_controller.selectedDay);
                await getChangedPageData(_controller.focusedDay);
                await getReservedHistoryData();

                Get.back();
              } catch (e) {
                showError(context, e.toString());
              }
            },
            isDestructiveAction: true,
            child: Text("수업 취소", style: TextStyle(fontSize: 24.r)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true,
          child: Text("닫기", style: TextStyle(fontSize: 24.r)),
        ),
      ),
    );
  }

  Future _showExtend(BuildContext context, Reservation reservation) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          DateFormat("yy/MM/dd HH:mm").format(reservation.startDate) +
              " ~ " +
              DateFormat("HH:mm")
                  .format(reservation.endDate.add(const Duration(minutes: 15))),
          style: TextStyle(fontSize: 24.r),
        ),
        message: Text("수업을 15분 연장 하시겠습니까?", style: TextStyle(fontSize: 24.r)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              try {
                await _client.extendReservation(reservation.id);

                await getUserBasedData();
                await getSelectedDayData(_controller.selectedDay);
                await getChangedPageData(_controller.focusedDay);
                await getReservedHistoryData();

                Get.back();
              } catch (e) {
                showError(context, e.toString());
              }
            },
            child: Text("수업 연장", style: TextStyle(fontSize: 24.r)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true,
          child: Text("닫기", style: TextStyle(fontSize: 24.r)),
        ),
      ),
    );
  }

  String _statusToString(int bookingStatus) {
    Map<int, String> status = {
      0: "Original",
      1: "MadeUp",
      2: "Canceled",
      3: "Extended",
      -1: "MadeUp(by Admin)",
      -2: "Canceled(by Admin)",
      -3: "Extended(by Admin)",
    };

    return status[bookingStatus]!;
  }
}
