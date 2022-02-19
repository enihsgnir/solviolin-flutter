import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/control.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/input.dart';

Widget _myDropdown<T>({
  required String title,
  T? value,
  required bool isMandatory,
  ValueChanged<T?>? onChanged,
  required List<DropdownMenuItem<T>> items,
}) {
  return Row(
    children: [
      label(title, isMandatory),
      Container(
        width: 220.r,
        child: DropdownButtonFormField<T>(
          value: value,
          hint: Text("선택", style: TextStyle(fontSize: 20.r)),
          icon: Icon(CupertinoIcons.arrowtriangle_down_square, size: 20.r),
          iconSize: 24.r,
          elevation: 16,
          style: contentStyle,
          onChanged: onChanged,
          onTap: () {
            FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());
          },
          items: items,
        ),
      ),
    ],
  );
}

Widget branchDropdown([
  String? tag,
  bool isMandatory = false,
]) {
  var _data = Get.find<DataController>();
  var _cache = Get.find<CacheController>(tag: tag);

  var _items = _data.branches
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ))
      .toList()
    ..addIf(
        !isMandatory,
        DropdownMenuItem(
          value: null,
          child: Text("선택"),
        ));

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<String>(
        title: "지점명",
        value: _cache.branchName,
        isMandatory: isMandatory,
        onChanged: (value) => setState(() {
          _cache.branchName = value;
        }),
        items: _items,
      );
    },
  );
}

Widget workDowDropdown([
  String? tag,
  bool isMandatory = false,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var _items = [0, 1, 2, 3, 4, 5, 6]
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e.dowToString),
          ))
      .toList()
    ..addIf(
        !isMandatory,
        DropdownMenuItem(
          value: null,
          child: Text("선택"),
        ));

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<int>(
        title: "요일",
        value: _cache.workDow,
        isMandatory: isMandatory,
        onChanged: (value) => setState(() {
          _cache.workDow = value;
        }),
        items: _items,
      );
    },
  );
}

Widget termDropdown([
  String? tag,
  bool isMandatory = false,
]) {
  var _data = Get.find<DataController>();
  var _cache = Get.find<CacheController>(tag: tag);

  var _items = _data.terms
      .map((e) => DropdownMenuItem(
            value: e.id,
            child: Text(formatDateRange(e.termStart, e.termEnd)),
          ))
      .toList()
    ..addIf(
        !isMandatory,
        DropdownMenuItem(
          value: null,
          child: Text("선택"),
        ));

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<int>(
        title: "학기",
        value: _cache.termID,
        isMandatory: isMandatory,
        onChanged: (value) => setState(() {
          _cache.termID = value;
        }),
        items: _items,
      );
    },
  );
}

Widget durationDropdown([
  String? tag,
  bool isMandatory = false,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var _items = [30, 45, 60]
      .map((e) => DropdownMenuItem(
            value: Duration(minutes: e),
            child: Text("$e분"),
          ))
      .toList()
    ..addIf(
        !isMandatory,
        DropdownMenuItem(
          value: null,
          child: Text("선택"),
        ));

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<Duration>(
        title: "수업시간",
        value: _cache.duration,
        isMandatory: isMandatory,
        onChanged: (value) => setState(() {
          _cache.duration = value;
        }),
        items: _items,
      );
    },
  );
}

Widget userTypeDropdown([
  String? tag,
  bool isMandatory = false,
]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var _items = UserType.values
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e.name),
          ))
      .toList()
    ..addIf(
        !isMandatory,
        DropdownMenuItem(
          value: null,
          child: Text("선택"),
        ));

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<UserType>(
        title: "구분",
        value: _cache.userType,
        isMandatory: isMandatory,
        onChanged: (value) => setState(() {
          _cache.userType = value;
        }),
        items: _items,
      );
    },
  );
}

/// This dropdown works with `cancelInCloseDropdown` of the same `tag`.
Widget controlStatusDropdown([String? tag]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var _items = ControlStatus.values
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e.name),
          ))
      .toList();

  return StatefulBuilder(
    builder: (context, setState) {
      return _myDropdown<ControlStatus>(
        title: "오픈/클로즈",
        value: _cache.controlStatus,
        isMandatory: true,
        onChanged: (value) {
          setState(() {
            _cache.controlStatus = value;
            if (value == ControlStatus.open) {
              _cache.cancelInClose = CancelInClose.none;
            }
          });
          _cache.update();
        },
        items: _items,
      );
    },
  );
}

/// This dropdown works with `controlStatusDropdown` of the same `tag`.
Widget cancelInCloseDropdown([String? tag]) {
  var _cache = Get.find<CacheController>(tag: tag);

  var _items = CancelInClose.values
      .map((e) => DropdownMenuItem(
            value: e,
            child: Text(e.name),
          ))
      .toList();

  return GetBuilder<CacheController>(
    tag: tag,
    builder: (controller) {
      return StatefulBuilder(
        builder: (context, setState) {
          return _myDropdown<CancelInClose>(
            title: "클로즈 시",
            value: _cache.cancelInClose,
            isMandatory: false,
            onChanged: _cache.controlStatus == ControlStatus.open
                ? null
                : (value) => setState(() {
                      _cache.cancelInClose = value;
                    }),
            items: _items,
          );
        },
      );
    },
  );
}
