import 'package:flutter/material.dart';
import 'package:solviolin/extensions/duration_copy_with_extension.dart';

const double _extent = 40;

class TimeSelectField extends StatefulWidget {
  final ValueChanged<Duration> onChanged;

  const TimeSelectField({
    super.key,
    required this.onChanged,
  });

  @override
  State<TimeSelectField> createState() => _TimeSelectFieldState();
}

class _TimeSelectFieldState extends State<TimeSelectField> {
  Duration time = Duration.zero;

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
                child: ListWheelScrollView.useDelegate(
                  physics: const FixedExtentScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemExtent: _extent,
                  onSelectedItemChanged: (value) {
                    time = time.copyWith(hours: value);
                    widget.onChanged(time);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: Duration.hoursPerDay,
                    builder: (context, index) {
                      final hour = index;
                      return Center(
                        child: Text(
                          "$hour시",
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
                child: ListWheelScrollView.useDelegate(
                  physics: const FixedExtentScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemExtent: _extent,
                  onSelectedItemChanged: (value) {
                    time = time.copyWith(minutes: value * 5);
                    widget.onChanged(time);
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: Duration.minutesPerHour ~/ 5,
                    builder: (context, index) {
                      final minute = index * 5;
                      return Center(
                        child: Text(
                          "$minute분",
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
