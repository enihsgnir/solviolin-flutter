import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

DataController _controller = Get.find<DataController>();

Widget branchDropdown([
  String? tag,
  String? validator,
]) {
  bool isMandatory = validator != null;

  Get.find<BranchController>(tag: tag);

  return GetBuilder<BranchController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110.r,
            child: label("지점명", isMandatory),
          ),
          Container(
            width: 220.r,
            child: DropdownButtonFormField<String>(
              value: controller.branchName,
              hint: Text("지점명", style: TextStyle(fontSize: 20.r)),
              icon: Icon(CupertinoIcons.arrowtriangle_down_square, size: 20.r),
              iconSize: 24.r,
              elevation: 16,
              style: TextStyle(color: Colors.white, fontSize: 20.r),
              validator: (value) {
                return value == null ? validator : null;
              },
              onChanged: (value) {
                controller.updateBranchName(value!);
              },
              onSaved: (value) {
                controller.updateBranchName(value!);
              },
              items: _controller.branches
                  .map<DropdownMenuItem<String>>(
                      (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
            ),
          ),
        ],
      );
    },
  );
}

Widget workDowDropdown([String? validator]) {
  bool isMandatory = validator != null;

  Get.find<WorkDowController>();

  return GetBuilder<WorkDowController>(
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110.r,
            child: label("요일", isMandatory),
          ),
          Container(
            width: 220.r,
            child: DropdownButtonFormField<int>(
              value: controller.workDow,
              hint: Text("요일", style: TextStyle(fontSize: 20.r)),
              icon: Icon(CupertinoIcons.arrowtriangle_down_square, size: 20.r),
              iconSize: 24.r,
              elevation: 16,
              style: TextStyle(color: Colors.white, fontSize: 20.r),
              validator: (value) {
                return value == null ? validator : null;
              },
              onChanged: (value) {
                controller.updateWorkDow(value!);
              },
              onSaved: (value) {
                controller.updateWorkDow(value!);
              },
              items: [for (int i = 0; i < 7; i++) i]
                  .map<DropdownMenuItem<int>>((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(dowToString(value)),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    },
  );
}

Widget termDropdown([String? validator]) {
  bool isMandatory = validator != null;

  Get.find<TermController>();

  return GetBuilder<TermController>(
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110.r,
            child: label("학기", isMandatory),
          ),
          Container(
            width: 220.r,
            child: DropdownButtonFormField<int>(
              value: controller.termID,
              hint: Text("학기", style: TextStyle(fontSize: 20.r)),
              icon: Icon(CupertinoIcons.arrowtriangle_down_square, size: 20.r),
              iconSize: 24.r,
              elevation: 16,
              style: TextStyle(color: Colors.white, fontSize: 20.r),
              validator: (value) {
                return value == null ? validator : null;
              },
              onChanged: (value) {
                controller.updateTermID(value!);
              },
              onSaved: (value) {
                controller.updateTermID(value!);
              },
              items: _controller.terms
                  .map<DropdownMenuItem<int>>((value) => DropdownMenuItem<int>(
                        value: value.id,
                        child: Text(
                          DateFormat("yy/MM/dd").format(value.termStart) +
                              " ~ " +
                              DateFormat("yy/MM/dd").format(value.termEnd),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    },
  );
}
