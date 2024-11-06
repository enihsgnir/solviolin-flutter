import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';

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

Widget myDialog({
  String? title,
  required List<Widget> contents,
  required VoidCallback onPressed,
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
          textAlign: TextAlign.center,
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
        onPressed: () {
          FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: symbolColor,
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
  required VoidCallback onPressed,
  String action = "확인",
  bool isScrollable = false,
}) {
  var dialog = myDialog(
    title: title,
    contents: contents,
    onPressed: onPressed,
    action: action,
  );

  if (isScrollable) {
    dialog = GestureDetector(
      onTap: () => FocusScope.of(Get.overlayContext!).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        child: dialog,
      ),
    );
  }

  return Get.dialog(
    dialog,
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
  required List<String> children,
  required List<bool> isDestructiveAction,
  required List<VoidCallback> onPressed,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: title == null
            ? null
            : Text(title, style: TextStyle(fontSize: 24.r)),
        message: Text(message, style: TextStyle(fontSize: 24.r)),
        actions: List.generate(
          children.length,
          (index) => CupertinoActionSheetAction(
            onPressed: onPressed[index],
            isDestructiveAction: isDestructiveAction[index],
            child: Text(children[index], style: TextStyle(fontSize: 24.r)),
          ),
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Get.back,
          isDefaultAction: true,
          child: Text("닫기", style: TextStyle(fontSize: 24.r)),
        ),
      );
    },
  );
}
