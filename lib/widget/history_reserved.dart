import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/format.dart';

class HistoryReserved extends StatefulWidget {
  final List<Reservation> reservations;

  const HistoryReserved({
    Key? key,
    required this.reservations,
  }) : super(key: key);

  @override
  _HistoryReservedState createState() => _HistoryReservedState();
}

class _HistoryReservedState extends State<HistoryReserved> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableScrollActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: "Cancel",
              color: Theme.of(context).scaffoldBackgroundColor,
              icon: Icons.remove,
              onTap: () {},
            ),
            IconSlideAction(
              caption: "Extend",
              color: Theme.of(context).scaffoldBackgroundColor,
              icon: Icons.add,
              onTap: () {},
            ),
          ],
          actionExtentRatio: 1 / 5,
          child: Container(
            margin: EdgeInsets.all(5),
            height: deviceWidth * 0.24,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${dateToString(widget.reservations[index].startDate)}"
                  " ${dateTimeToTimeString(widget.reservations[index].startDate)}"
                  "~${dateTimeToTimeString(widget.reservations[index].endDate)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    decoration:
                        widget.reservations[index].bookingStatus.abs() == 2
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 28,
                    decoration:
                        widget.reservations[index].bookingStatus.abs() == 2
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget.reservations[index].branchName),
                      Text(widget.reservations[index].teacherID),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: deviceWidth * 0.5,
                      height: deviceWidth * 0.05,
                    ),
                    Container(
                      child: Text(
                        bookingStatusToString(
                            widget.reservations[index].bookingStatus),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      itemCount: widget.reservations.length,
    );
  }
}
