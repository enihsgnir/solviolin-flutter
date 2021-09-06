import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';

Widget label(String item, bool isMandatory) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: item,
          style: TextStyle(color: Colors.white, fontSize: 20.r),
        ),
        TextSpan(
          text: isMandatory ? " *" : "",
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.r,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget myTextInput(
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

Widget myCheckBox({
  String? tag,
  required String item,
  required String trueName,
  required String falseName,
  bool reverse = false,
  bool isMandatory = false,
}) {
  bool trueValue = false;
  bool falseValue = false;

  Get.find<CheckController>(tag: tag);

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

                    if (trueValue && falseValue) {
                      controller.updateResult(null);
                    } else if (trueValue && !falseValue) {
                      controller.updateResult(reverse ? 0 : 1);
                    } else if (!trueValue && falseValue) {
                      controller.updateResult(reverse ? 1 : 0);
                    } else {
                      controller.updateResult(null);
                    }
                  });
                },
              ),
              Text(
                trueName,
                style: TextStyle(color: Colors.white, fontSize: 20.r),
              ),
              Checkbox(
                value: falseValue,
                onChanged: (value) {
                  setState(() {
                    falseValue = value!;

                    if (trueValue && falseValue) {
                      controller.updateResult(null);
                    } else if (trueValue && !falseValue) {
                      controller.updateResult(reverse ? 0 : 1);
                    } else if (!trueValue && falseValue) {
                      controller.updateResult(reverse ? 1 : 0);
                    } else {
                      controller.updateResult(null);
                    }
                  });
                },
              ),
              Text(
                falseName,
                style: TextStyle(color: Colors.white, fontSize: 20.r),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget myRadio<T>({
  String? tag,
  required String item,
  required List<String> names,
  required List<T> values,
  required T groupValue,
}) {
  RadioController<T> radio = Get.find<RadioController<T>>(tag: tag);
  radio.type = values[0];

  return StatefulBuilder(
    builder: (context, setState) {
      return DefaultTextStyle(
        style: TextStyle(color: Colors.white, fontSize: 20.r),
        child: Row(
          children: [
            Container(
              width: 120.r,
              child: label(item, true),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                names.length,
                (index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.r),
                  width: 65.r,
                  child: Column(
                    children: [
                      Text(names[index]),
                      Radio<T>(
                        value: values[index],
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });

                          radio.type = value!;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
