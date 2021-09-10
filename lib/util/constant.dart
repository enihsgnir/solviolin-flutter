import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';

DataController _controller = Get.find<DataController>();

extension RFS on num {
  double get r => this * _controller.ratio; //'r'esponsible font size
}

Color symbolColor = const Color.fromRGBO(96, 128, 104, 100);

BoxDecoration myDecoration = BoxDecoration(
  border: Border.all(color: Colors.grey),
  borderRadius: BorderRadius.circular(15.r),
);

TextStyle contentStyle = TextStyle(color: Colors.white, fontSize: 20.r);
