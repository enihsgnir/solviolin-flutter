import 'package:flutter/material.dart';
import 'package:solviolin/util/data_source.dart';

Widget indicator({required bool isActive}) {
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
