import 'package:flutter/material.dart';

class EditModeToggleButton extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const EditModeToggleButton({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onChanged(!enabled),
      child: Text(enabled ? "완료" : "편집"),
    );
  }
}
