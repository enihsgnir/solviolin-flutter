import 'dart:ui';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:json_annotation/json_annotation.dart';

// #RRGGBB
class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return colorFromHex(json)!;
  }

  @override
  String toJson(Color object) {
    return colorToHex(object, includeHashSign: true, enableAlpha: false);
  }
}
