import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/notification.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

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
          secondaryActions: [
            SlideAction(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.delete_left, size: 48),
                          Text(
                            "취소",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                          Icon(Icons.more_time, size: 48),
                          Text(
                            "연장",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
          actionExtentRatio: 1 / 5,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.reservations[index].teacherID}" +
                      " / ${widget.reservations[index].branchName}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    decoration:
                        widget.reservations[index].bookingStatus.abs() == 2
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
                Text(
                  DateFormat("yy/MM/dd HH:mm")
                          .format(widget.reservations[index].startDate) +
                      " ~ " +
                      DateFormat("HH:mm")
                          .format(widget.reservations[index].endDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
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
                    style: TextStyle(color: Colors.red, fontSize: 20),
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
