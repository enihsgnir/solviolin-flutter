import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';
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
  int hour = details.date!.hour;
  int minute = details.date!.minute ~/ 30 * 30;
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => SizedBox(
      height: 300,
      child: CupertinoActionSheet(
        title: Text("$hour:$minute"),
        message: const Text("Wanna Reserve?"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              print("Reserve");
            },
            child: const Text("Reserve"),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true,
          child: const Text("Close"),
        ),
      ),
    ),
  );
}

Future<void> modalReserveMk2(BuildContext context) async {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      onDateTimeChanged: (time) {},
      initialDateTime: DateTime.now(),
      minuteInterval: 15,
    ),
  );
}

Future<void> modalCancelOrExtend(BuildContext context) async {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: const Text("Choose Options"),
      message: const Text("Your options are "),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            print("Cancel");
            // Navigator.of(context).pop("Cancel");
          },
          isDestructiveAction: true,
          child: const Text("Cancel"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            print("Extend");
          },
          child: const Text("Extend"),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
        },
        isDefaultAction: true,
        child: const Text("Close"),
      ),
    ),
  );
}
