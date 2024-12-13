import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin/models/dow.dart';

class DowSelectField extends HookWidget {
  final Dow initialValue;
  final ValueChanged<Dow> onChanged;

  const DowSelectField({
    super.key,
    this.initialValue = Dow.sun,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue.inline);

    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: "요일을 선택하세요",
      ),
      readOnly: true,
      onTap: () async {
        final dow = await context.push<Dow>("/admin/dow/select");
        if (dow != null) {
          controller.text = dow.inline;
          onChanged(dow);
        }
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }
}
