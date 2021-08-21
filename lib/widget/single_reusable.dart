import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/format.dart';

DataController _controller = Get.find<DataController>();

Future showErrorMessage(BuildContext context, String message) {
  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text("Error", style: TextStyle(fontSize: 32.r)),
        content: Text(message, style: TextStyle(fontSize: 20.r)),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back();
            },
            child: Text("확인", style: TextStyle(fontSize: 24.r)),
          ),
        ],
      );
    },
  );
}

PreferredSizeWidget appBar(String title, {List<Widget>? actions}) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Icon(CupertinoIcons.chevron_back, size: 28.r),
    ),
    title: Text(title, style: TextStyle(fontSize: 28.r)),
    backgroundColor: Colors.transparent,
    actions: actions,
  );
}

Widget label(String item, bool isMandatory) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: item,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.r,
          ),
        ),
        TextSpan(
          text: isMandatory ? " *" : "",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.r,
            backgroundColor: Colors.transparent,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}

Widget input(
  String item,
  TextEditingController controller, [
  String? validator,
]) {
  bool isMandatory = validator != null;

  return Row(
    children: [
      Container(
        width: 110.r,
        child: label(item, isMandatory),
      ),
      Container(
        width: 220.r,
        child: TextFormField(
          controller: controller,
          validator: (value) {
            return value == "" ? validator : null;
          },
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
      ),
    ],
  );
}

Widget check({
  String? tag,
  required String item,
  required String trueName,
  required String falseName,
  bool reverse = false,
  bool isMandatory = false,
}) {
  Get.find<CheckController>(tag: tag);

  bool trueValue = false;
  bool falseValue = false;

  return GetBuilder<CheckController>(
    tag: tag,
    builder: (controller) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Row(
            children: [
              Container(
                width: 120.r,
                child: label(item, isMandatory),
              ),
              Checkbox(
                value: trueValue,
                onChanged: (value) {
                  setState(() {
                    trueValue = value!;

                    if (trueValue == true && falseValue == true) {
                      controller.updateResult(null);
                    } else if (trueValue == true && falseValue == false) {
                      controller.updateResult(reverse ? 0 : 1);
                    } else if (trueValue == false && falseValue == true) {
                      controller.updateResult(reverse ? 1 : 0);
                    } else {
                      controller.updateResult(null);
                    }
                  });
                },
              ),
              Text(
                trueName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.r,
                ),
              ),
              Checkbox(
                value: falseValue,
                onChanged: (value) {
                  setState(() {
                    falseValue = value!;

                    if (trueValue == true && falseValue == true) {
                      controller.updateResult(null);
                    } else if (trueValue == true && falseValue == false) {
                      controller.updateResult(reverse ? 0 : 1);
                    } else if (trueValue == false && falseValue == true) {
                      controller.updateResult(reverse ? 1 : 0);
                    } else {
                      controller.updateResult(null);
                    }
                  });
                },
              ),
              Text(
                falseName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.r,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget branchDropdown([
  String? tag,
  String? validator,
]) {
  Get.find<BranchController>(tag: tag);

  bool isMandatory = validator != null;

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
              onChanged: (String? value) {
                controller.updateBranchName(value!);
              },
              onSaved: (String? value) {
                controller.updateBranchName(value!);
              },
              items: List<String>.generate(
                _controller.branches.length,
                (index) => _controller.branches[index],
              )
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
  Get.find<WorkDowController>();

  bool isMandatory = validator != null;

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
              onChanged: (int? value) {
                controller.updateWorkDow(value!);
              },
              onSaved: (int? value) {
                controller.updateWorkDow(value!);
              },
              items: List<int>.generate(7, (index) => index)
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
  Get.find<TermController>();

  bool isMandatory = validator != null;

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
              onChanged: (int? value) {
                controller.updateTermID(value!);
              },
              onSaved: (int? value) {
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

Widget pickDateTime(
  BuildContext context,
  String item, [
  String? tag,
  bool isMandatory = false,
]) {
  Get.find<DateTimeController>(tag: tag);

  final DateTime initialDate = DateTime.now();
  DateTime? newDate;
  final TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay? newTime;

  return GetBuilder<DateTimeController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110.r,
            child: label(item, isMandatory),
          ),
          Container(
            width: 220.r,
            child: InputDecorator(
              decoration: const InputDecoration(),
              child: InkWell(
                child: Text(
                  controller.dateTime == null
                      ? "미선택"
                      : DateFormat("yy/MM/dd HH:mm")
                          .format(controller.dateTime!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.r,
                  ),
                ),
                onTap: () async {
                  newDate = await showDatePicker(
                    context: context,
                    initialDate: controller.date ?? initialDate,
                    firstDate:
                        DateTime(initialDate.year, initialDate.month - 5, 1),
                    lastDate: _controller.currentTerm[0].termEnd.add(
                        const Duration(hours: 23, minutes: 59, seconds: 59)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          textTheme: TextTheme(
                            headline5: TextStyle(fontSize: 24.r),
                            subtitle2: TextStyle(fontSize: 16.r),
                            caption: TextStyle(fontSize: 16.r),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (newDate != null) {
                    controller.updateDate(newDate);
                    newTime = await showTimePicker(
                      context: context,
                      initialTime: controller.time ?? initialTime,
                    );

                    if (newTime != null) {
                      controller.updateTime(newTime);
                      controller.updateDateTime(newDate!.add(Duration(
                        hours: newTime!.hour,
                        minutes: newTime!.minute,
                      )));
                    }
                  }
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget pickDate(
  BuildContext context,
  String item, [
  String? tag,
  bool isMandatory = false,
]) {
  Get.find<DateTimeController>(tag: tag);

  final DateTime initialDate = DateTime.now();
  DateTime? newDate;

  return GetBuilder<DateTimeController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110.r,
            child: label(item, isMandatory),
          ),
          Container(
            width: 220.r,
            child: InputDecorator(
              decoration: const InputDecoration(),
              child: InkWell(
                child: Text(
                  controller.date == null
                      ? "미선택"
                      : DateFormat("yy/MM/dd").format(controller.date!),
                  style: TextStyle(color: Colors.white, fontSize: 20.r),
                ),
                onTap: () async {
                  newDate = await showDatePicker(
                    context: context,
                    initialDate: controller.date ?? initialDate,
                    firstDate:
                        DateTime(initialDate.year, initialDate.month - 5, 1),
                    lastDate: _controller.currentTerm[0].termEnd.add(
                        const Duration(hours: 23, minutes: 59, seconds: 59)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          textTheme: TextTheme(
                            headline5: TextStyle(fontSize: 24.r),
                            subtitle2: TextStyle(fontSize: 16.r),
                            caption: TextStyle(fontSize: 16.r),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (newDate != null) {
                    controller.updateDate(newDate);
                  }
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget pickTime(
  BuildContext context,
  String item, [
  String? tag,
  bool isMandatory = false,
]) {
  Get.find<DateTimeController>(tag: tag);

  final TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay? newTime;

  return GetBuilder<DateTimeController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110.r,
            child: label(item, isMandatory),
          ),
          Container(
            width: 220.r,
            child: InputDecorator(
              decoration: const InputDecoration(),
              child: InkWell(
                child: Text(
                  controller.time == null
                      ? "아직 선택 안함"
                      : timeToString(Duration(
                          hours: controller.time!.hour,
                          minutes: controller.time!.minute,
                        )),
                  style: TextStyle(color: Colors.white, fontSize: 20.r),
                ),
                onTap: () async {
                  newTime = await showTimePicker(
                    context: context,
                    initialTime: controller.time ?? initialTime,
                  );

                  if (newTime != null) {
                    controller.updateTime(newTime);
                  }
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}
