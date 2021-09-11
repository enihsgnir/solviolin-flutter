import 'package:flutter/material.dart';
import 'package:solviolin/util/constant.dart';

Widget swipeableList({
  double? height,
  required int itemCount,
  required Widget Function(BuildContext, int) itemBuilder,
}) {
  var currentPage = 0;

  return StatefulBuilder(
    builder: (context, setState) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: height ?? 225.r, //TODO: shrinkwrap to child
            child: PageView.builder(
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                itemCount,
                (index) => _indicator(isActive: index == currentPage),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget mySwipeableCard({
  EdgeInsetsGeometry? padding,
  required List<Widget> children,
}) {
  return Container(
    padding: padding ?? EdgeInsets.symmetric(vertical: 16.r),
    decoration: myDecoration,
    width: double.infinity,
    margin: EdgeInsets.all(8.r),
    child: DefaultTextStyle(
      style: TextStyle(fontSize: 28.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    ),
  );
}

Widget _indicator({required bool isActive}) {
  return AnimatedContainer(
    decoration: BoxDecoration(
      color: isActive ? symbolColor : Colors.grey,
      shape: BoxShape.circle,
    ),
    width: isActive ? 12.r : 8.r,
    height: isActive ? 12.r : 8.r,
    margin: EdgeInsets.symmetric(horizontal: 8.r),
    duration: const Duration(milliseconds: 150),
  );
}
