import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solviolin/utils/formatters.dart';

class CostInputField extends HookWidget {
  final String hintText;
  final ValueChanged<int> onChanged;

  const CostInputField({
    super.key,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: "0원");

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        final digit = int.tryParse(value) ?? 0;
        onChanged(digit);

        final text = digit.format(number);
        controller.value = TextEditingValue(
          text: "$text원",
          selection: TextSelection.collapsed(offset: text.length),
        );
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }
}
