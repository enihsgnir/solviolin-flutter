import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/input.dart';

Widget pickDateTime(
  BuildContext context,
  String item, [
  String? tag,
  bool isMandatory = false,
]) {
  final DateTime initialDate = DateTime.now();
  DateTime? newDate;
  final TimeOfDay initialTime = TimeOfDay.now(); //TODO: to Duration
  TimeOfDay? newTime;

  Get.find<DateTimeController>(tag: tag);

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
                  style: TextStyle(color: Colors.white, fontSize: 20.r),
                ),
                onTap: () async {
                  newDate = await showDatePicker(
                    context: context,
                    initialDate: controller.date ?? initialDate,
                    firstDate: DateTime(initialDate.year - 3),
                    lastDate: DateTime(initialDate.year + 1),
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
  final DateTime initialDate = DateTime.now();
  DateTime? newDate;

  Get.find<DateTimeController>(tag: tag);

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
                    firstDate: DateTime(initialDate.year - 3),
                    lastDate: DateTime(initialDate.year + 1),
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
  final TimeOfDay initialTime = TimeOfDay.now();
  TimeOfDay? newTime;

  Get.find<DateTimeController>(tag: tag);

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
                      ? "미선택"
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
