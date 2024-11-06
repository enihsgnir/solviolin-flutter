import 'package:flutter/material.dart';
import 'package:solviolin_common/models/control.dart';
import 'package:solviolin_common/models/control_status.dart';
import 'package:solviolin_common/models/teacher.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// TODO: refactor all and add documentation

class _Schedule {
  List<DateTimeRange> open = [];
  List<DateTimeRange> close = [];
}

List<TimeRegion> calculateTimeRegions({
  required DateTime startOfWeek,
  required List<Teacher> teachers,
  required List<Control> controls,
  required Map<String, Color> colors,
}) {
  final schedules = <String, _Schedule>{};

  for (final e in teachers) {
    final offset = Duration(days: e.workDow.index);
    final start = startOfWeek.add(offset).add(e.startTime);
    final end = startOfWeek.add(offset).add(e.endTime);

    final range = DateTimeRange(start: start, end: end);

    final schedule = schedules.putIfAbsent(e.teacherID, () => _Schedule());
    schedule.open.add(range);
  }

  for (final e in controls) {
    final range = DateTimeRange(start: e.controlStart, end: e.controlEnd);

    final schedule = schedules.putIfAbsent(e.teacherID, () => _Schedule());
    switch (e.status) {
      case ControlStatus.open:
        schedule.open.add(range);

      case ControlStatus.close:
        schedule.close.add(range);
    }
  }

  for (final schedule in schedules.values) {
    schedule.open.sort((a, b) => a.start.compareTo(b.start));
    schedule.close.sort((a, b) => a.start.compareTo(b.start));

    schedule.open = schedule.open.merge();
    schedule.close = schedule.close.merge();

    schedule.open = schedule.open.difference(schedule.close);
    schedule.close = [];
  }

  return [
    for (final MapEntry(:key, :value) in schedules.entries)
      ...value.open.map((range) {
        return TimeRegion(
          startTime: range.start,
          endTime: range.end,
          color: (colors[key] ?? green).withOpacity(0.2),
          resourceIds: [key],
        );
      }),
  ];
}

extension on DateTimeRange {
  List<DateTimeRange> operator -(DateTimeRange other) {
    if (end.isBefore(other.start) || start.isAfter(other.end)) {
      // No overlap.
      return [this];
    }

    final startsBeforeOverlap = start.isBefore(other.start);
    final endsAfterOverlap = end.isAfter(other.end);

    if (startsBeforeOverlap && endsAfterOverlap) {
      return [
        DateTimeRange(start: start, end: other.start),
        DateTimeRange(start: other.end, end: end),
      ];
    } else if (startsBeforeOverlap) {
      return [DateTimeRange(start: start, end: other.start)];
    } else if (endsAfterOverlap) {
      return [DateTimeRange(start: other.end, end: end)];
    }
    return [];
  }
}

extension on List<DateTimeRange> {
  // `this` should be sorted.
  List<DateTimeRange> merge() {
    if (isEmpty) {
      return [];
    }

    final result = [first];
    for (final range in skip(1)) {
      final last = result.last;
      if (last.end.isBefore(range.start)) {
        result.add(range);
      } else {
        result.removeLast();
        result.add(DateTimeRange(start: last.start, end: range.end));
      }
    }

    return result;
  }

  // `this` and `other` should be sorted and merged.
  List<DateTimeRange> difference(List<DateTimeRange> other) {
    if (isEmpty || other.isEmpty) {
      return [...this];
    }

    final result = <DateTimeRange>[];

    int i = 0;
    int j = 0;
    while (i < length && j < other.length) {
      final a = this[i];
      final b = other[j];

      if (a.end.isBefore(b.start)) {
        result.add(a);
        i++;
      } else if (b.end.isBefore(a.start)) {
        j++;
      } else {
        result.addAll(a - b);
        i++;
      }
    }

    return result..addAll(skip(i));
  }
}
