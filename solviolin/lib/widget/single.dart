import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';

PreferredSizeWidget myAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
      onPressed: Get.back,
      icon: Icon(CupertinoIcons.chevron_back, size: 28.r),
    ),
    title: Text(title, style: TextStyle(fontSize: 28.r)),
    backgroundColor: Colors.transparent,
    actions: actions,
  );
}

Widget myDivider() {
  return Container(
    color: Colors.grey,
    height: 0.5,
    margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
  );
}

Widget menu(String name, VoidCallback onPressed, [bool isDestructive = false]) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isDestructive ? Colors.red : symbolColor,
      textStyle: TextStyle(color: Colors.white, fontSize: 22.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
    ),
    child: Container(
      alignment: Alignment.center,
      width: 135.r,
      height: 60.r,
      child: Text(name),
    ),
  );
}
