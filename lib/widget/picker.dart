import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/widget/input.dart';

Widget pickDateTime({
  required BuildContext context,
  required String item,
  String? tag,
  int index = 0,
  bool isMandatory = false,
}) {
  final initialDate = DateTime.now();
  DateTime? newDate;
  final initialTime = TimeOfDay.now();
  TimeOfDay? newTime;

  Get.find<CacheController>(tag: tag);

  return GetBuilder<CacheController>(
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
                  controller.dateTime[index] == null
                      ? "선택"
                      : DateFormat("yy/MM/dd HH:mm")
                          .format(controller.dateTime[index]!),
                  style: contentStyle,
                ),
                onTap: () async {
                  FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());

                  newDate = await showDatePicker(
                    context: context,
                    initialDate: controller.date[index] ?? initialDate,
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
                    newTime = await showTimePicker(
                      context: context,
                      initialTime: controller.time[index] ?? initialTime,
                    );

                    if (newTime != null) {
                      controller.dateTime[index] =
                          newDate!.add(timeOfDayToDuration(newTime!));
                      controller.update();
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

Widget pickDate({
  required BuildContext context,
  required String item,
  String? tag,
  int index = 0,
  bool isMandatory = false,
}) {
  final initialDate = DateTime.now();
  DateTime? newDate;

  Get.find<CacheController>(tag: tag);

  return GetBuilder<CacheController>(
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
                  controller.date[index] == null
                      ? "선택"
                      : DateFormat("yy/MM/dd").format(controller.date[index]!),
                  style: contentStyle,
                ),
                onTap: () async {
                  FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());

                  newDate = await showDatePicker(
                    context: context,
                    initialDate: controller.date[index] ?? initialDate,
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
                    controller.date[index] = newDate;
                    controller.update();
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

Widget pickTime({
  required BuildContext context,
  required String item,
  String? tag,
  int index = 0,
  bool isMandatory = false,
}) {
  final initialTime = TimeOfDay.now();
  TimeOfDay? newTime;

  Get.find<CacheController>(tag: tag);

  return GetBuilder<CacheController>(
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
                  controller.time[index] == null
                      ? "선택"
                      : timeToString(Duration(
                          hours: controller.time[index]!.hour,
                          minutes: controller.time[index]!.minute,
                        )),
                  style: contentStyle,
                ),
                onTap: () async {
                  FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());

                  newTime = await showTimePicker(
                    context: context,
                    initialTime: controller.time[index] ?? initialTime,
                  );

                  if (newTime != null) {
                    controller.time[index] = newTime;
                    controller.update();
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
