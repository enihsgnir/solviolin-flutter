import 'package:flutter/material.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/format.dart';

class ReservationHistory extends StatefulWidget {
  final List<Reservation> reservations;

  const ReservationHistory({
    Key? key,
    required this.reservations,
  }) : super(key: key);

  @override
  _ReservationHistoryState createState() => _ReservationHistoryState();
}

class _ReservationHistoryState extends State<ReservationHistory> {
  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).padding.left +
            MediaQuery.of(context).padding.right);

    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border(
              left: BorderSide(
                color: Colors.black45,
              ),
              bottom: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${dateToString(widget.reservations[index].startDate)}"
                " ${dateTimeToTimeString(widget.reservations[index].startDate)}"
                "~${dateTimeToTimeString(widget.reservations[index].endDate)}",
                style: TextStyle(
                  decoration:
                      widget.reservations[index].bookingStatus.abs() == 2
                          ? TextDecoration.lineThrough
                          : null,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.reservations[index].branchName,
                    style: TextStyle(
                      decoration:
                          widget.reservations[index].bookingStatus.abs() == 2
                              ? TextDecoration.lineThrough
                              : null,
                    ),
                  ),
                  Text(
                    widget.reservations[index].teacherID,
                    style: TextStyle(
                      decoration:
                          widget.reservations[index].bookingStatus.abs() == 2
                              ? TextDecoration.lineThrough
                              : null,
                    ),
                  ),
                ],
              ),
              Container(
                width: _deviceWidth,
                alignment: Alignment.centerRight,
                child: Text(
                  bookingStatusToString(
                      widget.reservations[index].bookingStatus),
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: widget.reservations.length,
    );
  }
}
