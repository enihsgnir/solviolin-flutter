import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';

Widget mySearch({
  EdgeInsetsGeometry? padding,
  required List<Widget> contents,
}) {
  return GestureDetector(
    onTap: () => FocusScope.of(Get.overlayContext!).requestFocus(FocusNode()),
    child: Container(
      padding: padding ?? EdgeInsets.symmetric(vertical: 8.r),
      decoration: myDecoration,
      margin: EdgeInsets.all(8.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          contents.length,
          (index) => Padding(
            padding: EdgeInsets.fromLTRB(24.r, 3.r, 0, 3.r),
            child: contents[index],
          ),
        ),
      ),
    ),
  );
}

Widget myActionButton({
  required BuildContext context,
  required void Function() onPressed,
  String action = "검색",
}) {
  return Padding(
    padding: EdgeInsets.only(left: 24.r),
    child: ElevatedButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onPressed();
      },
      style: ElevatedButton.styleFrom(primary: symbolColor),
      child: Text(action, style: contentStyle),
    ),
  );
}
