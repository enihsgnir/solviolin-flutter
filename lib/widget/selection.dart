import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';

DataController _controller = Get.find<DataController>();

class BranchController extends GetxController {
  String? branchName;

  void updateBranchName(String data) {
    branchName = data;
    update();
  }
}

Widget branchDropdown([
  String? tag,
  String? validator,
  bool isMandatory = false,
]) {
  Get.find<BranchController>(tag: tag);

  return GetBuilder<BranchController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "지점명",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: isMandatory ? " *" : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      backgroundColor: Colors.transparent,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 220,
            child: DropdownButtonFormField<String>(
              value: controller.branchName,
              hint: Text(
                "지점명",
                style: TextStyle(fontSize: 20),
              ),
              icon: Icon(
                CupertinoIcons.arrowtriangle_down_square,
                size: 20,
              ),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              autovalidateMode: AutovalidateMode.always,
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

class WorkDowController extends GetxController {
  int? workDow;

  void updateWorkDow(int data) {
    workDow = data;
    update();
  }
}

Widget workDowDropdown([String? validator, bool isMandatory = false]) {
  Get.find<WorkDowController>();

  return GetBuilder<WorkDowController>(
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "요일",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: isMandatory ? " *" : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      backgroundColor: Colors.transparent,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 220,
            child: DropdownButtonFormField<int>(
              value: controller.workDow,
              hint: Text(
                "요일",
                style: TextStyle(fontSize: 20),
              ),
              icon: Icon(
                CupertinoIcons.arrowtriangle_down_square,
                size: 20,
              ),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
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

class TermController extends GetxController {
  int? termID;

  void updateTermID(int data) {
    termID = data;
    update();
  }
}

Widget termDropdown([String? validator, bool isMandatory = false]) {
  Get.find<TermController>();

  return GetBuilder<TermController>(
    builder: (controller) {
      return Row(
        children: [
          Container(
            width: 110,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "학기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: isMandatory ? " *" : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      backgroundColor: Colors.transparent,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 220,
            child: DropdownButtonFormField<int>(
              value: controller.termID,
              hint: Text(
                "학기",
                style: TextStyle(fontSize: 20),
              ),
              icon: Icon(
                CupertinoIcons.arrowtriangle_down_square,
                size: 20,
              ),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
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

class CheckController extends GetxController {
  int? result;

  void updateResult(int? data) {
    result = data;
    update();
  }
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
                width: 120,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: item,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: isMandatory ? " *" : "",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          backgroundColor: Colors.transparent,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
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
                  fontSize: 20,
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
                  fontSize: 20,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class DateTimeController extends GetxController {
  DateTime? date;
  TimeOfDay? time;
  DateTime? dateTime;

  void updateDate(DateTime? data) {
    date = data;
    update();
  }

  void updateTime(TimeOfDay? data) {
    time = data;
    update();
  }

  void updateDateTime(DateTime? data) {
    dateTime = data;
    update();
  }
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
            width: 110,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: item,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: isMandatory ? " *" : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      backgroundColor: Colors.transparent,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 220,
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
                    fontSize: 20,
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
            width: 110,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: item,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: isMandatory ? " *" : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      backgroundColor: Colors.transparent,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 220,
            child: InputDecorator(
              decoration: const InputDecoration(),
              child: InkWell(
                child: Text(
                  controller.date == null
                      ? "미선택"
                      : DateFormat("yy/MM/dd").format(controller.date!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
            width: 110,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: item,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: isMandatory ? " *" : "",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      backgroundColor: Colors.transparent,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 220,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: InkWell(
              child: Text(
                controller.time == null
                    ? "아직 선택 안함"
                    : timeToString(Duration(
                        hours: controller.time!.hour,
                        minutes: controller.time!.minute,
                      )),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
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
        ],
      );
    },
  );
}
