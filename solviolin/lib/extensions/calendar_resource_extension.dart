import 'package:syncfusion_flutter_calendar/calendar.dart';

extension CalendarResourceExtension on CalendarResource? {
  /// Returns `true` if this resource is not `null` and not classified as
  /// "others". Otherwise, returns `false`.
  bool get isNotOthers => (this?.id ?? "") != "";
}
