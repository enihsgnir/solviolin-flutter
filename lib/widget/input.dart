import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';

Widget label(String item, bool isMandatory) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(text: item, style: contentStyle),
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

//TODO: add number keypad type with keyboardType: TextInputType.number
Widget myTextInput(
  String item,
  TextEditingController controller, [
  String? validator,
]) {
  return Row(
    children: [
      Container(
        width: 110.r,
        child: label(item, validator != null),
      ),
      Container(
        width: 220.r,
        child: TextFormField(
          keyboardType: TextInputType.name,
          controller: controller,
          validator: (value) => value == "" ? validator : null,
          style: contentStyle,
        ),
      ),
    ],
  );
}

Widget myCheckBox({
  String? tag,
  int index = 0,
  required String item,
  required String trueName,
  required String falseName,
  bool isReversed = false,
  bool isMandatory = false,
}) {
  bool _trueValue = false;
  bool _falseValue = false;

  var _cache = Get.find<CacheController>(tag: tag);

  return StatefulBuilder(
    builder: (context, setState) {
      return Row(
        children: [
          Container(
            width: 120.r,
            child: label(item, isMandatory),
          ),
          Checkbox(
            value: _trueValue,
            onChanged: (value) {
              setState(() {
                _trueValue = value!;

                if (_trueValue && _falseValue) {
                  _cache.check[index] = null;
                } else if (_trueValue && !_falseValue) {
                  _cache.check[index] = isReversed ? 0 : 1;
                } else if (!_trueValue && _falseValue) {
                  _cache.check[index] = isReversed ? 1 : 0;
                } else {
                  _cache.check[index] = null;
                }
              });
            },
          ),
          Text(trueName, style: contentStyle),
          Checkbox(
            value: _falseValue,
            onChanged: (value) {
              setState(() {
                _falseValue = value!;

                if (_trueValue && _falseValue) {
                  _cache.check[index] = null;
                } else if (_trueValue && !_falseValue) {
                  _cache.check[index] = isReversed ? 0 : 1;
                } else if (!_trueValue && _falseValue) {
                  _cache.check[index] = isReversed ? 1 : 0;
                } else {
                  _cache.check[index] = null;
                }
              });
            },
          ),
          Text(falseName, style: contentStyle),
        ],
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
  var _cache = Get.find<CacheController>(tag: tag);
  _cache.type[T] = groupValue;

  return StatefulBuilder(
    builder: (context, setState) {
      return DefaultTextStyle(
        style: contentStyle,
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

                          _cache.type[T] = value!;
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
