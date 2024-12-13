import 'package:json_annotation/json_annotation.dart';
import 'package:solviolin/utils/formatters.dart';

// hh:mm
class TimeConverter implements JsonConverter<Duration, String> {
  const TimeConverter();

  @override
  Duration fromJson(String json) {
    final times = json.split(":").map(int.parse).toList();
    return Duration(hours: times[0], minutes: times[1]);
  }

  @override
  String toJson(Duration object) {
    return object.format(durationTime);
  }
}
