import 'package:flutter/material.dart';
import 'package:solviolin_common/models/cancel_in_close.dart';
import 'package:solviolin_common/utils/theme.dart';

class CancelInCloseSelectField extends StatefulWidget {
  final bool enabled;
  final ValueChanged<CancelInClose> onChanged;

  const CancelInCloseSelectField({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<CancelInCloseSelectField> createState() =>
      _CancelInCloseSelectFieldState();
}

class _CancelInCloseSelectFieldState extends State<CancelInCloseSelectField> {
  bool none = true;
  bool cancel = false;
  bool delete = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.enabled
                ? () {
                    setState(() {
                      none = true;
                      cancel = false;
                      delete = false;
                    });
                    widget.onChanged(CancelInClose.none);
                  }
                : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: none ? blue : black,
              side: BorderSide(
                color: widget.enabled && none ? blue : gray600,
              ),
            ),
            child: const Text("유지"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: widget.enabled
                ? () {
                    setState(() {
                      cancel = true;
                      none = false;
                      delete = false;
                    });
                    widget.onChanged(CancelInClose.cancel);
                  }
                : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: cancel ? blue : black,
              side: BorderSide(
                color: widget.enabled && cancel ? blue : gray600,
              ),
            ),
            child: const Text("취소"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: widget.enabled
                ? () {
                    setState(() {
                      delete = true;
                      none = false;
                      cancel = false;
                    });
                    widget.onChanged(CancelInClose.delete);
                  }
                : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: delete ? blue : black,
              side: BorderSide(
                color: widget.enabled && delete ? blue : gray600,
              ),
            ),
            child: const Text("삭제"),
          ),
        ),
      ],
    );
  }
}
