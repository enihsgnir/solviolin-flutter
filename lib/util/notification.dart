import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/format.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Future<void> showErrorMessage(BuildContext context) async {
  DataController _controller = Get.find<DataController>();

  if (_controller.messages.isNotEmpty) {
    LinkedHashSet<String> messages = LinkedHashSet.from(_controller.messages);
    _controller.resetMessages();

    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("오류가 발생했습니다!"),
          content: ListBody(
            children: List<Text>.generate(
              messages.length,
              (index) => Text("${messages.elementAt(index)}"),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Get.back();
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }
}

Future<void> modalReserve(
    BuildContext context, CalendarTapDetails details) async {
  Client client = Get.put(Client());
  DataController _controller = Get.find<DataController>();
  DateTime _start = details.date!;
  int _startHour = _start.hour;
  int _startMinute = _start.minute ~/ 30 * 30;
  DateTime _startDate =
      DateTime(_start.year, _start.month, _start.day, _startHour, _startMinute);
  DateTime _end = _startDate.add(Duration(minutes: 30));
  int _endHour = _end.hour;
  int _endMinute = _end.minute;

  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text("${twoDigits(_startHour)}:${twoDigits(_startMinute)}"
          " ~ ${twoDigits(_endHour)}:${twoDigits(_endMinute)}"),
      message: const Text("예약 하시겠습니까?"),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            await client.makeUpReservation(
              teacherID: _controller.teachers[0].teacherID,
              branchName: _controller.regularSchedules[0].branchName,
              startDate: _startDate,
              endDate: _startDate.add(_controller.regularSchedules[0].endTime -
                  _controller.regularSchedules[0].startTime),
              userID: _controller.user.userID,
            );
          },
          child: const Text("예약"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
        },
        isDefaultAction: true,
        child: const Text("닫기"),
      ),
    ),
  );
}

Future<void> modalCancelOrExtend(
    BuildContext context, CalendarTapDetails details) async {
  Client client = Get.put(Client());
  List<Reservation> reservations = details.appointments as List<Reservation>;

  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            await client.cancelReservation("${reservations[0].id}");
            getUserBaseData();
          },
          isDestructiveAction: true,
          child: const Text("예약 취소"),
        ),
        CupertinoActionSheetAction(
          onPressed: () async {
            await client.extendReservation("${reservations[0].id}");
            getUserBaseData();
          },
          child: const Text("예약 연장"),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
        },
        isDefaultAction: true,
        child: const Text("닫기"),
      ),
    ),
  );
}
