import 'package:flutter/material.dart';
import 'package:solviolin/utils/theme.dart';

class DurationSelectField extends StatefulWidget {
  final ValueChanged<Duration> onChanged;

  const DurationSelectField({
    super.key,
    required this.onChanged,
  });

  @override
  State<DurationSelectField> createState() => _DurationSelectFieldState();
}

class _DurationSelectFieldState extends State<DurationSelectField> {
  bool minute30 = true;
  bool minute45 = false;
  bool minute60 = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                minute30 = true;
                minute45 = false;
                minute60 = false;
              });
              widget.onChanged(const Duration(minutes: 30));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: minute30 ? blue : black,
              side: BorderSide(
                color: minute30 ? blue : gray600,
              ),
            ),
            child: const Text("30분"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                minute45 = true;
                minute30 = false;
                minute60 = false;
              });
              widget.onChanged(const Duration(minutes: 45));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: minute45 ? blue : black,
              side: BorderSide(
                color: minute45 ? blue : gray600,
              ),
            ),
            child: const Text("45분"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                minute60 = true;
                minute30 = false;
                minute45 = false;
              });
              widget.onChanged(const Duration(minutes: 60));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: minute60 ? blue : black,
              side: BorderSide(
                color: minute60 ? blue : gray600,
              ),
            ),
            child: const Text("60분"),
          ),
        ),
      ],
    );
  }
}
