import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BranchSelectField extends StatefulWidget {
  final String? initialValue;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  const BranchSelectField({
    super.key,
    this.initialValue,
    this.readOnly = false,
    required this.onChanged,
  });

  @override
  State<BranchSelectField> createState() => _BranchSelectFieldState();
}

class _BranchSelectFieldState extends State<BranchSelectField> {
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
        hintText: "지점명을 선택하세요",
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

        final branchName = await context.push<String>("/admin/branch/select");
        if (branchName != null) {
          controller.text = branchName;
          widget.onChanged(branchName);
        }
      },
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }
}
