import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solviolin/model/reservation.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/format.dart';
import 'package:solviolin/util/network.dart';

Future showErrorMessage(BuildContext context, String message) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("Error", style: TextStyle(fontSize: 32.sp)),
        content: Text(message, style: TextStyle(fontSize: 20.sp)),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child: Text("확인", style: TextStyle(fontSize: 24.sp)),
          ),
        ],
      );
    },
  );
}

Future showModalReserve(BuildContext context, DateTime time) {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  Duration duration = controller.regularSchedules[0].endTime -
      controller.regularSchedules[0].startTime;

  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(
        "${dateTimeToString(time)} ~ ${dateTimeToTimeString(time.add(duration))}",
        style: TextStyle(fontSize: 24.sp),
      ),
      message: Text("예약 하시겠습니까?", style: TextStyle(fontSize: 24.sp)),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            try {
              await client.makeUpReservation(
                teacherID: controller.regularSchedules[0].teacherID,
                branchName: controller.user.branchName,
                startDate: time,
                endDate: time.add(duration),
                userID: controller.user.userID,
              );
              try {
                await getUserBasedData();
                await getSelectedDayData(controller.selectedDay);
                await getChangedPageData(controller.focusedDay);
              } catch (e) {
                await client.logout();
                Get.offAllNamed("/login");
                showErrorMessage(context, e.toString());
              }
            } catch (e) {
              try {
                await getUserBasedData();
                await getSelectedDayData(controller.selectedDay);
                await getChangedPageData(controller.focusedDay);
              } catch (e) {
                await client.logout();
                Get.offAllNamed("/login");
                showErrorMessage(context, e.toString());
              }
              Get.back();
              showErrorMessage(context, e.toString());
            }
          },
          child: Text("예약", style: TextStyle(fontSize: 24.sp)),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
        },
        isDefaultAction: true,
        child: Text("닫기", style: TextStyle(fontSize: 24.sp)),
      ),
    ),
  );
}

Future showModalCancel(BuildContext context, Reservation reservation) {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(
        "${dateTimeToString(reservation.startDate)}" +
            " ~ ${dateTimeToTimeString(reservation.endDate)}",
        style: TextStyle(fontSize: 24.sp),
      ),
      message: Text("예약을 취소 하시겠습니까?", style: TextStyle(fontSize: 24.sp)),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            try {
              await client.cancelReservation("${reservation.id}");
              try {
                await getUserBasedData();
                await getSelectedDayData(controller.selectedDay);
                await getChangedPageData(controller.focusedDay);
              } catch (e) {
                await client.logout();
                Get.offAllNamed("/login");
                showErrorMessage(context, e.toString());
              }
            } catch (e) {
              Get.back();
              showErrorMessage(context, e.toString());
            }
          },
          isDestructiveAction: true,
          child: Text("예약 취소", style: TextStyle(fontSize: 24.sp)),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
        },
        isDefaultAction: true,
        child: Text("닫기", style: TextStyle(fontSize: 24.sp)),
      ),
    ),
  );
}

Future showModalExtend(BuildContext context, Reservation reservation) {
  Client client = Get.put(Client());
  DataController controller = Get.find<DataController>();

  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(
        "${dateTimeToString(reservation.startDate)}" +
            " ~ ${dateTimeToTimeString(reservation.endDate.add(Duration(minutes: 15)))}",
        style: TextStyle(fontSize: 24.sp),
      ),
      message: Text("예약을 15분 연장 하시겠습니까?", style: TextStyle(fontSize: 24.sp)),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            try {
              await client.extendReservation("${reservation.id}");
              try {
                await getUserBasedData();
                await getSelectedDayData(controller.selectedDay);
                await getChangedPageData(controller.focusedDay);
              } catch (e) {
                await client.logout();
                Get.offAllNamed("/login");
                showErrorMessage(context, e.toString());
              }
            } catch (e) {
              Get.back();
              showErrorMessage(context, e.toString());
            }
          },
          child: Text("예약 연장", style: TextStyle(fontSize: 24.sp)),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
        },
        isDefaultAction: true,
        child: Text("닫기", style: TextStyle(fontSize: 24.sp)),
      ),
    ),
  );
}
