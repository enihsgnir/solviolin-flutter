import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeacherIDSelectField extends StatefulWidget {
  final String branchName;
  final String? initialValue;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  const TeacherIDSelectField({
    super.key,
    required this.branchName,
    this.initialValue,
    this.readOnly = false,
    required this.onChanged,
  });

  @override
  State<TeacherIDSelectField> createState() => _TeacherIDSelectFieldState();
}

class _TeacherIDSelectFieldState extends State<TeacherIDSelectField> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final initialValue = widget.initialValue;
    if (initialValue != null) {
      controller.text = initialValue;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onChanged(initialValue);
      });
    }
  }

  @override
  void didUpdateWidget(TeacherIDSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branchName != widget.branchName) {
      controller.clear();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onChanged("");
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void reset() {
    controller.clear();
    widget.onChanged("");
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "강사를 선택하세요",
        suffixIcon: widget.readOnly
            ? null
            : IconButton(
                onPressed: reset,
                icon: const Icon(Icons.clear_rounded),
              ),
      ),
      readOnly: true,
      onTap: () async {
        if (widget.readOnly) {
          return;
        }

        final uri = Uri(
          path: "/admin/teacher/select",
          queryParameters: {
            "branchName": widget.branchName,
          },
        );

        final teacherID = await context.push<String>(uri.toString());
        if (teacherID != null) {
          controller.text = teacherID;
          widget.onChanged(teacherID);
        }
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }
}
