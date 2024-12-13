import 'package:flutter/material.dart';
import 'package:solviolin/extensions/date_time_extension.dart';
import 'package:solviolin/utils/formatters.dart';

const double _extent = 40;

const int _yearOffset = 2000;

class DateSelectField extends StatefulWidget {
  final DateTime? initialValue;
  final ValueChanged<DateTime> onChanged;

  const DateSelectField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<DateSelectField> createState() => _DateSelectFieldState();
}

class _DateSelectFieldState extends State<DateSelectField> {
  final today = DateTime.now().dateOnly;

  late DateTime date = today;
  final yearController = FixedExtentScrollController();
  final monthController = FixedExtentScrollController();
  final dayController = FixedExtentScrollController();

  void jumpToDate(DateTime newDate) {
    date = newDate;
    yearController.jumpToItem(newDate.year - _yearOffset);
    monthController.jumpToItem(newDate.month - 1);
    dayController.jumpToItem(newDate.day - 1);
  }

  void setAdjustedDate({
    int? year,
    int? month,
  }) {
    final targetYear = year ?? date.year;
    final targetMonth = month ?? date.month;

    final daysInMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    final targetDay = date.day.clamp(1, daysInMonth);

    date = DateTime(targetYear, targetMonth, targetDay);
    dayController.jumpToItem(targetDay - 1);
  }

  @override
  void initState() {
    super.initState();

    final initialValue = widget.initialValue ?? today;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      jumpToDate(initialValue);
      widget.onChanged(initialValue);
    });
  }

  @override
  void didUpdateWidget(DateSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      final initialValue = widget.initialValue ?? today;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        jumpToDate(initialValue);
        widget.onChanged(initialValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _extent * 3,
      decoration: const ShapeDecoration(
        shape: OutlineInputBorder(),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            top: _extent,
            bottom: _extent,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ListWheelScrollView.useDelegate(
                  controller: yearController,
                  physics: const FixedExtentScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemExtent: _extent,
                  onSelectedItemChanged: (value) {
                    setState(() {
                      setAdjustedDate(year: _yearOffset + value);
                    });
                    widget.onChanged(date);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: (today.year + 5) - _yearOffset,
                    builder: (context, index) {
                      final year = _yearOffset + index;
                      return Center(
                        child: Text(
                          "$year년",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListWheelScrollView.useDelegate(
                  controller: monthController,
                  physics: const FixedExtentScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemExtent: _extent,
                  onSelectedItemChanged: (value) {
                    setState(() {
                      setAdjustedDate(month: value + 1);
                    });
                    widget.onChanged(date);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: DateTime.monthsPerYear,
                    builder: (context, index) {
                      final month = index + 1;
                      return Center(
                        child: Text(
                          "$month월",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListWheelScrollView.useDelegate(
                  controller: dayController,
                  physics: const FixedExtentScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemExtent: _extent,
                  onSelectedItemChanged: (value) {
                    date = date.copyWith(day: value + 1);
                    widget.onChanged(date);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: DateTime(date.year, date.month + 1, 0).day,
                    builder: (context, index) {
                      final day = index + 1;
                      final dow = DateTime(date.year, date.month, day).weekday;
                      return Center(
                        child: Text(
                          "$day일(${dow.format(weekday)})",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
