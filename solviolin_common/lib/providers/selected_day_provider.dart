import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';

part 'selected_day_provider.g.dart';

@riverpod
class SelectedDay extends _$SelectedDay {
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
