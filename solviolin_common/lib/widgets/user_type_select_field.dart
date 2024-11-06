import 'package:flutter/material.dart';
import 'package:solviolin_common/models/user_type.dart';
import 'package:solviolin_common/utils/theme.dart';

class UserTypeSelectField extends StatefulWidget {
  final ValueChanged<UserType> onChanged;

  const UserTypeSelectField({
    super.key,
    required this.onChanged,
  });

  @override
  State<UserTypeSelectField> createState() => _UserTypeSelectFieldState();
}

class _UserTypeSelectFieldState extends State<UserTypeSelectField> {
  bool student = true;
  bool teacher = false;
  bool admin = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                student = true;
                teacher = false;
                admin = false;
              });
              widget.onChanged(UserType.student);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: student ? blue : black,
              side: BorderSide(
                color: student ? blue : gray600,
              ),
            ),
            child: const Text("수강생"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                teacher = true;
                student = false;
                admin = false;
              });
              widget.onChanged(UserType.teacher);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: teacher ? blue : black,
              side: BorderSide(
                color: teacher ? blue : gray600,
              ),
            ),
            child: const Text("강사"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                admin = true;
                student = false;
                teacher = false;
              });
              widget.onChanged(UserType.admin);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: admin ? blue : black,
              side: BorderSide(
                color: admin ? blue : gray600,
              ),
            ),
            child: const Text("관리자"),
          ),
        ),
      ],
    );
  }
}
