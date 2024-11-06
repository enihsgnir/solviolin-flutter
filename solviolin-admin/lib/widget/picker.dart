import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var initialDate = DateTime.now();
  DateTime? newDate;
  var initialTime = TimeOfDay.now();
  TimeOfDay? newTime;

  Get.find<CacheController>(tag: tag);

  return GetBuilder<CacheController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          label(item, isMandatory),
          Container(
            width: 220.r,
            child: InputDecorator(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.dateTime[index] = null;
                    controller.update();
                  },
                  icon: Icon(Icons.clear, size: 20.r),
                  splashRadius: 20.r,
                ),
              ),
              child: InkWell(
                child: Text(
                  controller.dateTime[index] == null
                      ? "선택"
                      : formatDateTime(controller.dateTime[index]!),
                  style: contentStyle,
                  textAlign: TextAlign.left,
                ),
                onTap: () async {
                  FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());

                  newDate = await showDatePicker(
                    context: context,
                    initialDate: controller.date[index] ?? initialDate,
                    firstDate: DateTime(initialDate.year - 3),
                    lastDate: DateTime(initialDate.year + 2, 1, 0),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark(),
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
  var initialDate = DateTime.now();
  DateTime? newDate;

  Get.find<CacheController>(tag: tag);

  return GetBuilder<CacheController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          label(item, isMandatory),
          Container(
            width: 220.r,
            child: InputDecorator(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.date[index] = null;
                    controller.update();
                  },
                  icon: Icon(Icons.clear, size: 20.r),
                  splashRadius: 20.r,
                ),
              ),
              child: InkWell(
                child: Text(
                  controller.date[index] == null
                      ? "선택"
                      : formatDate(controller.date[index]!),
                  style: contentStyle,
                  textAlign: TextAlign.left,
                ),
                onTap: () async {
                  FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());

                  newDate = await showDatePicker(
                    context: context,
                    initialDate: controller.date[index] ?? initialDate,
                    firstDate: DateTime(initialDate.year - 3),
                    lastDate: DateTime(initialDate.year + 2, 1, 0),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark(),
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
  var initialTime = TimeOfDay.now();
  TimeOfDay? newTime;

  Get.find<CacheController>(tag: tag);

  return GetBuilder<CacheController>(
    tag: tag,
    builder: (controller) {
      return Row(
        children: [
          label(item, isMandatory),
          Container(
            width: 220.r,
            child: InputDecorator(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.time[index] = null;
                    controller.update();
                  },
                  icon: Icon(Icons.clear, size: 20.r),
                  splashRadius: 20.r,
                ),
              ),
              child: InkWell(
                child: Text(
                  controller.time[index] == null
                      ? "선택"
                      : timeToString(Duration(
                          hours: controller.time[index]!.hour,
                          minutes: controller.time[index]!.minute,
                        )),
                  style: contentStyle,
                  textAlign: TextAlign.left,
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
