import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/input.dart';

DataController _controller = Get.find<DataController>();

Widget _myDropdown<T>({
  required String title,
  T? value,
  String? validator,
  void Function(T?)? onChanged,
  required List<DropdownMenuItem<T>> items,
}) {
  return Row(
    children: [
      Container(
        width: 110.r,
        child: label(title, validator != null),
      ),
      Container(
        width: 220.r,
        child: DropdownButtonFormField<T>(
          value: value,
          hint: Text(title, style: TextStyle(fontSize: 20.r)),
          icon: Icon(CupertinoIcons.arrowtriangle_down_square, size: 20.r),
          iconSize: 24.r,
          elevation: 16,
          style: contentStyle,
          validator: (value) => value == null ? validator : null,
          onChanged: onChanged,
          onSaved: onChanged,
          items: items,
        ),
      ),
    ],
  );
}

Widget branchDropdown([
  String? tag,
  String? validator,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  return _myDropdown<String>(
    title: "지점명",
    value: _cache.branchName,
    validator: validator,
    onChanged: (value) => _cache.branchName = value,
    items: _controller.branches
        .map<DropdownMenuItem<String>>((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList(),
  );
}

Widget workDowDropdown([
  String? tag,
  String? validator,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  return _myDropdown<int>(
    title: "요일",
    value: _cache.workDow,
    validator: validator,
    onChanged: (value) => _cache.workDow = value,
    items: [for (int i = 0; i < 7; i++) i]
        .map<DropdownMenuItem<int>>((value) => DropdownMenuItem(
              value: value,
              child: Text(dowToString(value)),
            ))
        .toList(),
  );
}

Widget termDropdown([
  String? tag,
  String? validator,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  return _myDropdown<int>(
    title: "학기",
    value: _cache.termID,
    validator: validator,
    onChanged: (value) => _cache.termID = value,
    items: _controller.terms
        .map<DropdownMenuItem<int>>((value) => DropdownMenuItem(
              value: value.id,
              child: Text(DateFormat("yy/MM/dd").format(value.termStart) +
                  " ~ " +
                  DateFormat("yy/MM/dd").format(value.termEnd)),
            ))
        .toList(),
  );
}
