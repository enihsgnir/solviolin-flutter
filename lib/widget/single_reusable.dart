import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future showErrorMessage(BuildContext context, String message) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("Error", style: TextStyle(fontSize: 32)),
        content: Text(message, style: TextStyle(fontSize: 20)),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child: Text("확인", style: TextStyle(fontSize: 24)),
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
      icon: Icon(CupertinoIcons.chevron_back, size: 28),
    ),
    title: Text(title, style: TextStyle(fontSize: 28)),
    backgroundColor: Colors.transparent,
    actions: actions,
  );
}

Widget input(String item, TextEditingController controller,
    [String? validator]) {
  return Row(
    children: [
      Container(
        width: 110,
        child: Text(
          item,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      Container(
        width: 220,
        child: TextFormField(
          controller: controller,
          validator: (value) {
            return value == "" ? validator : null;
          },
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  );
}
