import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';

Future showError(String message) {
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
        child: Text(action, style: TextStyle(fontSize: 20.r)),
      ),
    ],
  );
}

Future showMyDialog({
  required BuildContext context,
  String? title,
  required List<Widget> contents,
  required void Function() onPressed,
  String action = "확인",
  bool isScrolling = false,
}) {
  var dialog = myDialog(
    title: title,
    contents: contents,
    onPressed: onPressed,
    action: action,
  );

  if (isScrolling) {
    dialog = GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          SingleChildScrollView(
            child: dialog,
          ),
        ],
      ),
    );
  }

  return showDialog(
    context: context,
    barrierColor: Colors.black26,
    builder: (context) {
      return dialog;
    },
  );
}

Future showLoading() {
  return Get.dialog(
    Center(
      child: Container(
        width: 80.r,
        height: 80.r,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
        ),
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.black12,
  );
}
