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
      child: Container(
        width: 90.r,
        height: 90.r,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
        ),
      ),
    ),
    opacityColor: Colors.black12,
    opacity: 1,
  );
}

Future<void> showMySnackbar({
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
