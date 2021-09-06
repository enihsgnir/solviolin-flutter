import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';

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
