import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';

Future showError(dynamic error) {
  var message = error.toString();
  if (error is CastError) {
    message = "필수 항목을 입력하세요.";
  } else if (error is FormatException) {
    message = "입력값의 형식이 올바르지 않습니다.";
  } else if (error is TypeError || error is NoSuchMethodError) {
    message = "아래 메시지와 함께 관리자에게 문의하세요!\n" + message;
  }

  return Get.dialog(
    CupertinoAlertDialog(
      title: Text("Error", style: TextStyle(fontSize: 32.r)),
      content: Text(message, style: TextStyle(fontSize: 20.r)),
      actions: [
        CupertinoDialogAction(
          onPressed: Get.back,
          child: Text("확인", style: TextStyle(fontSize: 24.r)),
        ),
      ],
    ),
    barrierDismissible: false,
    barrierColor: Colors.black26,
  );
}

Widget myDialog({
  String? title,
  required List<Widget> contents,
  required void Function() onPressed,
  required String action,
}) {
  return AlertDialog(
    title: title == null
        ? null
        : Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 28.r),
          ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        contents.length,
        (index) => DefaultTextStyle(
          style: contentStyle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.r, horizontal: 12.r),
            child: contents[index],
          ),
        ),
      ),
    ),
    actions: [
      OutlinedButton(
        onPressed: Get.back,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
        ),
        child: Text("취소", style: contentStyle),
      ),
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: symbolColor,
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
        ),
        child: Text(action, style: contentStyle),
      ),
    ],
  );
}

Future showMyDialog({
  String? title,
  required List<Widget> contents,
  required void Function() onPressed,
  String action = "확인",
}) {
  return Get.dialog(
    myDialog(
      title: title,
      contents: contents,
      onPressed: onPressed,
      action: action,
    ),
    barrierColor: Colors.black26,
  );
}

Future<void> showLoading(Future<void> Function() asyncFunction) {
  return Get.showOverlay<void>(
    asyncFunction: asyncFunction,
    loadingWidget: Center(
      child: CupertinoActivityIndicator(radius: 30.r),
    ),
    opacityColor: Colors.black12,
    opacity: 1,
  );
}

Future showMySnackbar({
  String title = "성공",
  required String message,
}) async {
  return Get.snackbar(
    "",
    "",
    titleText: Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 24.r),
    ),
    messageText: Text(message, style: contentStyle),
  );
}

// Future _showModalExtend(BuildContext context, Reservation reservation) {
//   return showCupertinoModalPopup(
//     context: context,
//     builder: (context) {
//       return CupertinoActionSheet(
//         title: Text(
//           formatDateTimeRange(reservation.startDate,
//               reservation.endDate.add(const Duration(minutes: 15))),
//           style: TextStyle(fontSize: 24.r),
//         ),
//         message: Text("수업을 15분 연장 하시겠습니까?", style: TextStyle(fontSize: 24.r)),
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () => showLoading(() async {
//               try {
//                 await _client.extendReservation(reservation.id);

//                 await getUserBasedData();
//                 await getSelectedDayData(_data.selectedDay);
//                 await getChangedPageData(_data.focusedDay);
//                 await getReservedHistoryData();

//                 Get.back();

//                 await showMySnackbar(
//                   message: "수업 연장에 성공했습니다.",
//                 );
//               } catch (e) {
//                 showError(e);
//               }
//             }),
//             child: Text("수업 연장", style: TextStyle(fontSize: 24.r)),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           onPressed: Get.back,
//           isDefaultAction: true,
//           child: Text("닫기", style: TextStyle(fontSize: 24.r)),
//         ),
//       );
//     },
//   );
// }

// Future? showMyModal() {}
