import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin/utils/theme.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  String label = "확인",
  bool isDestructive = false,
  required List<Widget> content,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...content,
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.pop(false),
                      style: FilledButton.styleFrom(
                        backgroundColor: gray100,
                        foregroundColor: gray800,
                      ),
                      child: const Text("닫기"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.pop(true),
                      style: FilledButton.styleFrom(
                        backgroundColor: isDestructive ? red : null,
                      ),
                      child: Text(label),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
