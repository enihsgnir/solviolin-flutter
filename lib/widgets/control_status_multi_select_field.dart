import 'package:flutter/material.dart';
import 'package:solviolin/models/control_status.dart';
import 'package:solviolin/utils/theme.dart';

class ControlStatusMultiSelectField extends StatefulWidget {
  final ValueChanged<ControlStatus?> onChanged;

  const ControlStatusMultiSelectField({
    super.key,
    required this.onChanged,
  });

  @override
  State<ControlStatusMultiSelectField> createState() =>
      _ControlStatusMultiSelectFieldState();
}

class _ControlStatusMultiSelectFieldState
    extends State<ControlStatusMultiSelectField> {
  bool open = true;
  bool close = true;

  void onPressed() {
    if (open && close) {
      widget.onChanged(null);
    } else if (open) {
      widget.onChanged(ControlStatus.open);
    } else if (close) {
      widget.onChanged(ControlStatus.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                open = !open;
                if (!open && !close) {
                  close = true;
                }
              });
              onPressed();
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
                close = !close;
                if (!open && !close) {
                  open = true;
                }
              });
              onPressed();
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
