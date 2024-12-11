import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/extensions/date_time_extension.dart';
import 'package:solviolin/providers/calendar_events_provider.dart';
import 'package:solviolin/providers/focused_day_provider.dart';
import 'package:solviolin/providers/selected_day_provider.dart';
import 'package:solviolin/providers/term_list_provider.dart';
import 'package:solviolin/widgets/status_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class MakeUpCalendar extends ConsumerWidget {
  const MakeUpCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termList = ref.watch(termListProvider).valueOrNull ?? [];
    if (termList.isEmpty) {
      return const LoadingStatusWidget();
    }

    final events = ref.watch(calendarEventsProvider).valueOrNull ?? {};
    final selectedDay = ref.watch(selectedDayProvider);
    final focusedDay = ref.watch(focusedDayProvider);

    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: termList.last.termStart,
      lastDay: termList.first.termEnd,
      pageJumpingEnabled: true,
      availableGestures: AvailableGestures.horizontalSwipe,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextFormatter: (date, locale) => "${date.year}년 ${date.month}월",
      ),
      selectedDayPredicate: (day) => day.dateOnly == selectedDay,
      holidayPredicate: (day) => events.contains(day.dateOnly),
      onDaySelected: (selectedDay, focusedDay) {
        ref.read(selectedDayProvider.notifier).setValue(selectedDay);
        ref.read(focusedDayProvider.notifier).setValue(focusedDay);
      },
      onPageChanged: (focusedDay) {
        ref.read(selectedDayProvider.notifier).setValue(focusedDay);
        ref.read(focusedDayProvider.notifier).setValue(focusedDay);
      },
    );
  }
}
