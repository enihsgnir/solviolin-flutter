import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/controller.dart';

// TODO: turn global constants into class methods.
//  Not supported with auto import for extension methods yet.

extension ResponsibleFontSize on num {
  /// `r`esponsible font size
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
