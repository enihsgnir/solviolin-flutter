import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/input.dart';

DataController _data = Get.find<DataController>();

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
          hint: Text("선택", style: TextStyle(fontSize: 20.r)),
          icon: Icon(CupertinoIcons.arrowtriangle_down_square, size: 20.r),
          iconSize: 24.r,
          elevation: 16,
          style: contentStyle,
          validator: (value) => value == null ? validator : null,
          onChanged: onChanged,
          onSaved: onChanged,
          onTap: () =>
              FocusScope.of(Get.overlayContext!).requestFocus(FocusNode()),
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

  var items = _data.branches
      .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList();
  if (validator == null) {
    items.add(DropdownMenuItem(
      value: null,
      child: Text("선택"),
    ));
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<String>(
        title: "지점명",
        value: _cache.branchName,
        validator: validator,
        onChanged: (value) => setState(() {
          _cache.branchName = value;
        }),
        items: items,
      );
    },
  );
}

Widget workDowDropdown([
  String? tag,
  String? validator,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var items = [for (int i = 0; i < 7; i++) i]
      .map<DropdownMenuItem<int>>((e) => DropdownMenuItem(
            value: e,
            child: Text(dowToString(e)),
          ))
      .toList();
  if (validator == null) {
    items.add(DropdownMenuItem(
      value: null,
      child: Text("선택"),
    ));
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<int>(
        title: "요일",
        value: _cache.workDow,
        validator: validator,
        onChanged: (value) => setState(() {
          _cache.workDow = value;
        }),
        items: items,
      );
    },
  );
}

Widget termDropdown([
  String? tag,
  String? validator,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var items = _data.terms
      .map<DropdownMenuItem<int>>((e) => DropdownMenuItem(
            value: e.id,
            child: Text(DateFormat("yy/MM/dd").format(e.termStart) +
                " ~ " +
                DateFormat("yy/MM/dd").format(e.termEnd)),
          ))
      .toList();
  if (validator == null) {
    items.add(DropdownMenuItem(
      value: null,
      child: Text("선택"),
    ));
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<int>(
        title: "학기",
        value: _cache.termID,
        validator: validator,
        onChanged: (value) => setState(() {
          _cache.termID = value;
        }),
        items: items,
      );
    },
  );
}

Widget durationDropdown([
  String? tag,
  String? validator,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var items = [30, 45, 60]
      .map<DropdownMenuItem<Duration>>((e) => DropdownMenuItem(
            value: Duration(minutes: e),
            child: Text("$e분"),
          ))
      .toList();
  if (validator == null) {
    items.add(DropdownMenuItem(
      value: null,
      child: Text("선택"),
    ));
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<Duration>(
        title: "수업시간",
        value: _cache.duration,
        validator: validator,
        onChanged: (value) => setState(() {
          _cache.duration = value;
        }),
        items: items,
      );
    },
  );
}
