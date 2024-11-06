import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';

Future showError(dynamic error) {
  var message = error.toString();
  if (error is FormatException) {
    message = "입력값의 형식이 올바르지 않습니다.";
  } else if (error is StateError) {
    message = "조건에 해당하는 값이 존재하지 않습니다.";
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

Future showMyModal({
  required BuildContext context,
  String? title,
  required String message,
  required String child,
  bool isDestructiveAction = false,
  required VoidCallback onPressed,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: title == null
            ? null
            : Text(title, style: TextStyle(fontSize: 24.r)),
        message: Text(message, style: TextStyle(fontSize: 24.r)),
        actions: [
          CupertinoActionSheetAction(
            onPressed: onPressed,
            isDestructiveAction: isDestructiveAction,
            child: Text(child, style: TextStyle(fontSize: 24.r)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: Get.back,
          isDefaultAction: true,
          child: Text("닫기", style: TextStyle(fontSize: 24.r)),
        ),
      );
    },
  );
}
