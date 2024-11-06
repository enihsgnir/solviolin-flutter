import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/cancel_in_close.dart';
import 'package:solviolin_common/models/control.dart';
import 'package:solviolin_common/models/control_status.dart';
import 'package:solviolin_common/providers/client_state/control_state_provider.dart';
import 'package:solviolin_common/providers/control_list_provider.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';

class ControlListTile extends ConsumerWidget {
  final Control control;
  final bool showActions;

  const ControlListTile(
    this.control, {
    super.key,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cancelInClose = control.cancelInClose;
    final start = control.controlStart.format(dateTime);
    final end = control.controlEnd.format(dateTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(control.status.label, style: titleLarge),
              const SizedBox(width: 8),
              Text("${control.branchName} ${control.teacherID}"),
              const Spacer(),
              if (showActions)
                TextButton(
                  onPressed: () => showDelete(context, ref),
                  child: const Text("삭제"),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (control.status == ControlStatus.close &&
              cancelInClose != null) ...[
            RichText(
              text: TextSpan(
                style: captionLarge.copyWith(color: gray600),
                children: [
                  const TextSpan(text: "기간 중 수업을 "),
                  TextSpan(
                    text: cancelInClose.label,
                    style: cancelInClose == CancelInClose.none
                        ? null
                        : const TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                  const TextSpan(text: "합니다"),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text("$start 부터"),
          const SizedBox(height: 4),
          Text("$end 까지"),
        ],
      ),
    );
  }

  Future<void> showDelete(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text("오픈/클로즈를 삭제하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(controlStateProvider.notifier)
        .delete(control.id)
        .withLoadingOverlay(context);

    ref.invalidate(controlListProvider);
  }
}
