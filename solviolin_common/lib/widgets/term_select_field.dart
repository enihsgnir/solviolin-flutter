import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin_common/models/term.dart';

class TermSelectField extends StatefulWidget {
  final Term? initialValue;
  final ValueChanged<int> onChanged;

  const TermSelectField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<TermSelectField> createState() => _TermSelectFieldState();
}

class _TermSelectFieldState extends State<TermSelectField> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final initialValue = widget.initialValue;
    if (initialValue != null) {
      controller.text = initialValue.inline;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onChanged(initialValue.id);
      });
    }
  }

  @override
  void didUpdateWidget(covariant TermSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      controller.text = widget.initialValue?.inline ?? "";

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onChanged(widget.initialValue?.id ?? 0);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: "학기를 선택하세요",
      ),
      readOnly: true,
      onTap: () async {
        final term = await context.push<Term>("/admin/term/select");
        if (term != null) {
          controller.text = term.inline;
          widget.onChanged(term.id);
        }
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }
}
