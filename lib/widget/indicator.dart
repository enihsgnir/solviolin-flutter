import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget indicator({required bool isActive}) {
  return AnimatedContainer(
    decoration: BoxDecoration(
      color: isActive ? const Color.fromRGBO(96, 128, 104, 100) : Colors.grey,
      shape: BoxShape.circle,
    ),
    width: isActive ? 12.r : 8.r,
    height: isActive ? 12.r : 8.r,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    duration: const Duration(milliseconds: 150),
  );
}
