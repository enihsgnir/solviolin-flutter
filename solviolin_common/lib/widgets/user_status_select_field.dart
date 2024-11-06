import 'package:flutter/material.dart';
import 'package:solviolin_common/models/user_status.dart';
import 'package:solviolin_common/utils/theme.dart';

class UserStatusSelectField extends StatefulWidget {
  final UserStatus initialValue;
  final ValueChanged<UserStatus> onChanged;

  const UserStatusSelectField({
    super.key,
    this.initialValue = UserStatus.registered,
    required this.onChanged,
  });

  @override
  State<UserStatusSelectField> createState() => _UserStatusSelectFieldState();
}

class _UserStatusSelectFieldState extends State<UserStatusSelectField> {
  bool unregistered = false;
  bool registered = true;

  @override
  void initState() {
    super.initState();

    unregistered = widget.initialValue == UserStatus.unregistered;
    registered = widget.initialValue == UserStatus.registered;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChanged(widget.initialValue);
    });
  }

  @override
  void didUpdateWidget(UserStatusSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          unregistered = widget.initialValue == UserStatus.unregistered;
          registered = widget.initialValue == UserStatus.registered;
        });
        widget.onChanged(widget.initialValue);
      });
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
                unregistered = true;
                registered = false;
              });
              widget.onChanged(UserStatus.unregistered);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: unregistered ? blue : black,
              side: BorderSide(
                color: unregistered ? blue : gray600,
              ),
            ),
            child: const Text("미등록"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                registered = true;
                unregistered = false;
              });
              widget.onChanged(UserStatus.registered);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: registered ? blue : black,
              side: BorderSide(
                color: registered ? blue : gray600,
              ),
            ),
            child: const Text("등록"),
          ),
        ),
      ],
    );
  }
}
