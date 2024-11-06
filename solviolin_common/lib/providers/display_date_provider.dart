import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';

part 'display_date_provider.g.dart';

@riverpod
class DisplayDate extends _$DisplayDate {
  @override
  DateTime build() {
    return DateTime.now().dateOnly;
  }

  void setValue(DateTime value) {
    if (state != value) {
      state = value;
    }
  }
}
