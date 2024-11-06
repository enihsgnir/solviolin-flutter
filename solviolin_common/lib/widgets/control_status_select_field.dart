import 'package:flutter/material.dart';
import 'package:solviolin_common/models/control_status.dart';
import 'package:solviolin_common/utils/theme.dart';

class ControlStatusSelectField extends StatefulWidget {
  final ValueChanged<ControlStatus> onChanged;

  const ControlStatusSelectField({
    super.key,
    required this.onChanged,
  });

  @override
  State<ControlStatusSelectField> createState() =>
      _ControlStatusSelectFieldState();
}

class _ControlStatusSelectFieldState extends State<ControlStatusSelectField> {
  bool open = true;
  bool close = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                open = true;
                close = false;
              });
              widget.onChanged(ControlStatus.open);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: open ? blue : black,
              side: BorderSide(
                color: open ? blue : gray600,
              ),
            ),
            child: const Text("오픈"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                close = true;
                open = false;
              });
              widget.onChanged(ControlStatus.close);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: close ? blue : black,
              side: BorderSide(
                color: close ? blue : gray600,
              ),
            ),
            child: const Text("클로즈"),
          ),
        ),
      ],
    );
  }
}
