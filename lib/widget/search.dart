import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';

Widget mySearch({
  ExpandableController? controller,
  EdgeInsetsGeometry? padding,
  required List<Widget> contents,
}) {
  return ExpandablePanel(
    header: Container(
      padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0.r),
      child: Text(
        "Search",
        style: TextStyle(color: Colors.white, fontSize: 24.r),
      ),
    ),
    collapsed: Container(),
    expanded: GestureDetector(
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
    ),
    controller: controller,
    theme: ExpandableThemeData(
      iconColor: Colors.white,
      iconSize: 20.r,
      iconPadding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
      iconRotationAngle: pi / 2,
      expandIcon: Icons.arrow_forward_ios,
      collapseIcon: Icons.arrow_forward_ios,
    ),
  );
}

Widget myActionButton({
  required BuildContext context,
  required VoidCallback onPressed,
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
