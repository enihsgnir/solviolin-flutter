import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/extensions/date_time_extension.dart';

part 'focused_day_provider.g.dart';

@riverpod
class FocusedDay extends _$FocusedDay {
  @override
  DateTime build() {
    return DateTime.now().dateOnly;
  }

  void setValue(DateTime value) {
    final newState = value.dateOnly;
    if (state != newState) {
      state = newState;
    }
  }
}
