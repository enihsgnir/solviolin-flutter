import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/notification.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.reservations.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableScrollActionPane(),
          actionExtentRatio: 1 / 5,
          secondaryActions: [
            SlideAction(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.delete_left, size: 48.r),
                          Text(
                            "취소",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          )
                        ],
                      ),
                      onTap: () async {
                        widget.reservations[index].bookingStatus.abs() == 2
                            ? showErrorMessage(context, "이미 취소된 수업입니다.")
                            : await showModalCancel(
                                context, widget.reservations[index]);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white,
                    width: 0.25,
                  ),
                ],
              ),
            ),
            SlideAction(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: Colors.white,
                    width: 0.25,
                  ),
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.more_time, size: 48.r),
                          Text(
                            "연장",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ),
                          )
                        ],
                      ),
                      onTap: () async {
                        widget.reservations[index].bookingStatus.abs() == 3
                            ? showErrorMessage(context, "이미 연장된 수업입니다.")
                            : await showModalExtend(
                                context, widget.reservations[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.r),
            ),
            height: 108.h,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.reservations[index].teacherID}" +
                      " / ${widget.reservations[index].branchName}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    decoration:
                        widget.reservations[index].bookingStatus.abs() == 2
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
                Text(
                  "${dateTimeToString(widget.reservations[index].startDate)}" +
                      " ~ ${dateTimeToTimeString(widget.reservations[index].endDate)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    decoration:
                        widget.reservations[index].bookingStatus.abs() == 2
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  width: double.infinity,
                  child: Text(
                    bookingStatusToString(
                        widget.reservations[index].bookingStatus),
                    style: TextStyle(color: Colors.red, fontSize: 20.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
