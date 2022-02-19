import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:solviolin/util/constant.dart';

Widget myNormalCard({
  EdgeInsetsGeometry? padding,
  required List<Widget> children,
}) {
  return Container(
    padding: padding ?? EdgeInsets.symmetric(vertical: 16.r),
    decoration: myDecoration,
    width: double.infinity,
    margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
    child: DefaultTextStyle(
      style: TextStyle(fontSize: 24.r),
      textAlign: TextAlign.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ),
  );
}

Widget mySlidableCard({
  List<Widget>? slideActions,
  EdgeInsetsGeometry? padding,
  required List<Widget> children,
}) {
  return Slidable(
    actionPane: const SlidableScrollActionPane(),
    actionExtentRatio: 1 / 5,
    secondaryActions: slideActions,
    child: Container(
      padding: padding ?? EdgeInsets.symmetric(vertical: 16.r),
      decoration: myDecoration,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 24.r),
        textAlign: TextAlign.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    ),
  );
}

Widget mySlideAction({
  required BuildContext context,
  required IconData icon,
  required String item,
  required VoidCallback onTap,
  bool borderLeft = false,
  bool borderRight = false,
}) {
  return SlideAction(
    child: Row(
      children: [
        borderLeft
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 8.r),
                color: Colors.white,
                width: 0.25.r,
              )
            : Container(),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48.r),
                Text(item, style: contentStyle)
              ],
            ),
          ),
        ),
        borderRight
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 8.r),
                color: Colors.white,
                width: 0.25.r,
              )
            : Container(),
      ],
    ),
    onTap: onTap,
  );
}
