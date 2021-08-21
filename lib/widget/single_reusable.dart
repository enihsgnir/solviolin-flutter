import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/data_source.dart';

Future showError(BuildContext context, String message) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("Error", style: TextStyle(fontSize: 32.r)),
        content: Text(message, style: TextStyle(fontSize: 20.r)),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child: Text("확인", style: TextStyle(fontSize: 24.r)),
          ),
        ],
      );
    },
  );
}

PreferredSizeWidget appBar(String title, {List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(CupertinoIcons.chevron_back, size: 28.r),
    ),
    title: Text(title, style: TextStyle(fontSize: 28.r)),
    backgroundColor: Colors.transparent,
    actions: actions,
  );
}
