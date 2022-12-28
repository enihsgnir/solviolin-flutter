import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';

Widget label(String item, bool isMandatory) {
  return Container(
    width: 120.r,
    child: RichText(
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
    ),
  );
}

Widget myTextInput(
  String item,
  TextEditingController controller, {
  bool isMandatory = false,
  TextInputType? keyboardType,
  String? hintText,
}) {
  return Row(
    children: [
      label(item, isMandatory),
      Container(
        width: 220.r,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              onPressed: controller.clear,
              icon: Icon(Icons.clear, size: 20.r),
              splashRadius: 20.r,
            ),
          ),
          keyboardType: keyboardType,
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
  var _cache = Get.find<CacheController>(tag: tag);
  var _check = _cache.check[index];

  var _trueValue = false;
  var _falseValue = false;

  if (_check == 1) {
    _trueValue = isReversed ? false : true;
    _falseValue = !_trueValue;
  } else if (_check == 0) {
    _trueValue = isReversed ? true : false;
    _falseValue = !_trueValue;
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return Row(
        children: [
          label(item, isMandatory),
          Checkbox(
            value: _trueValue,
            onChanged: (value) {
              setState(() {
                _trueValue = value!;

                if (_trueValue && _falseValue) {
                  _trueValue = true;
                  _falseValue = false;
                  _cache.check[index] = isReversed ? 0 : 1;
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
                  _trueValue = false;
                  _falseValue = true;
                  _cache.check[index] = isReversed ? 1 : 0;
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
