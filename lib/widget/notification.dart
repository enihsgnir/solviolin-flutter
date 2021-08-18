import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

Client _client = Get.put(Client());

Future showModalCancel(BuildContext context, Reservation reservation) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: Text(
          DateFormat("HH:mm").format(reservation.startDate) +
              " ~ " +
              DateFormat("HH:mm").format(reservation.endDate),
          style: TextStyle(fontSize: 24),
        ),
        message: Text("수업을 취소 하시겠습니까?", style: TextStyle(fontSize: 24)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              try {
                await _client.cancelReservation(reservation.id);
                try {} catch (e) {
                  await _client.logout();
                  Get.offAllNamed("/login");
                  showErrorMessage(context, e.toString());
                }
              } catch (e) {
                Get.back();
                showErrorMessage(context, e.toString());
              }
            },
            isDestructiveAction: true,
            child: Text("수업 취소", style: TextStyle(fontSize: 24)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true,
          child: Text("닫기", style: TextStyle(fontSize: 24)),
        ),
      );
    },
  );
}

Future showModalExtend(BuildContext context, Reservation reservation) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: Text(
          DateFormat("yy/MM/dd HH:mm").format(reservation.startDate) +
              " ~ " +
              DateFormat("HH:mm")
                  .format(reservation.endDate.add(Duration(minutes: 15))),
          style: TextStyle(fontSize: 24),
        ),
        message: Text("수업을 15분 연장 하시겠습니까?", style: TextStyle(fontSize: 24)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              try {
                await _client.extendReservation(reservation.id);
                try {} catch (e) {
                  await _client.logout();
                  Get.offAllNamed("/login");
                  showErrorMessage(context, e.toString());
                }
              } catch (e) {
                Get.back();
                showErrorMessage(context, e.toString());
              }
            },
            child: Text("수업 연장", style: TextStyle(fontSize: 24)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true,
          child: Text("닫기", style: TextStyle(fontSize: 24)),
        ),
      );
    },
  );
}
