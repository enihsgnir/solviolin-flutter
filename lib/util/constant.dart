import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';

/// Responsible Font Size
extension RFS on num {
  /// 'r'esponsible font size
  double get r {
    var _data = Get.find<DataController>();

    return this * _data.ratio;
  }
}

Color symbolColor = const Color.fromRGBO(96, 128, 104, 100);

BoxDecoration myDecoration = BoxDecoration(
  border: Border.all(color: Colors.grey),
  borderRadius: BorderRadius.circular(15.r),
);

TextStyle contentStyle = TextStyle(color: Colors.white, fontSize: 20.r);
