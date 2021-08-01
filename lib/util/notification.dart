import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/util/format.dart';

Future showErrorMessage(BuildContext context, String message) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text("오류가 발생했습니다!", style: TextStyle(fontSize: 24)),
        content: Text(message, style: TextStyle(fontSize: 24)),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child: const Text("확인", style: TextStyle(fontSize: 24)),
          ),
        ],
      );
    },
  );
}

Future modalReserve(BuildContext context, DateTime time) {
  Client client = Get.put(Client());
  DataController _controller = Get.find<DataController>();

  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(
        "${dateTimeToTimeString(time)}",
        style: TextStyle(fontSize: 24),
      ),
      message: const Text("예약 하시겠습니까?", style: TextStyle(fontSize: 24)),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () async {
            try {
              await client.makeUpReservation(
                teacherID: _controller.teachers[0].teacherID,
                branchName: _controller.regularSchedules[0].branchName,
                startDate: time,
                endDate: time.add(_controller.regularSchedules[0].endTime -
                    _controller.regularSchedules[0].startTime),
                userID: _controller.user.userID,
              );
              try {
                await getUserBasedData();
              } catch (e) {
                Get.offAllNamed("/login");
                showErrorMessage(context, e.toString());
              }
            } catch (e) {
              Get.back();
              showErrorMessage(context, e.toString());
            }
          },
          child: const Text("예약", style: TextStyle(fontSize: 24)),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Get.back();
        },
        isDefaultAction: true,
        child: const Text("닫기", style: TextStyle(fontSize: 24)),
      ),
    ),
  );
}

// Future modalCancelOrExtend(BuildContext context, CalendarTapDetails details) {
//   Client client = Get.put(Client());
//   List<Reservation> reservations = details.appointments as List<Reservation>;

//   return showCupertinoModalPopup(
//     context: context,
//     builder: (context) => CupertinoActionSheet(
//       actions: [
//         CupertinoActionSheetAction(
//           onPressed: () async {
//             try {
//               await client.cancelReservation("${reservations[0].id}");
//               try {
//                 await getUserBasedData();
//               } catch (e) {
//                 Get.offAllNamed("/login");
//                 showErrorMessage(context, e.toString());
//               }
//             } catch (e) {
//               Get.back();
//               showErrorMessage(context, e.toString());
//             }
//           },
//           isDestructiveAction: true,
//           child: const Text("예약 취소", style: TextStyle(fontSize: 24)),
//         ),
//         CupertinoActionSheetAction(
//           onPressed: () async {
//             try {
//               await client.extendReservation("${reservations[0].id}");
//               try {
//                 await getUserBasedData();
//               } catch (e) {
//                 Get.offAllNamed("/login");
//                 showErrorMessage(context, e.toString());
//               }
//             } catch (e) {
//               Get.back();
//               showErrorMessage(context, e.toString());
//             }
//           },
//           child: const Text("예약 연장", style: TextStyle(fontSize: 24)),
//         )
//       ],
//       cancelButton: CupertinoActionSheetAction(
//         onPressed: () {
//           Get.back();
//         },
//         isDefaultAction: true,
//         child: const Text("닫기", style: TextStyle(fontSize: 24)),
//       ),
//     ),
//   );
// }
