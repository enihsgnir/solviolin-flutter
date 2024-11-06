import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/user.dart';
import 'package:solviolin_common/providers/client_state/user_state_provider.dart';
import 'package:solviolin_common/providers/user_list_provider.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';
import 'package:solviolin_common/widgets/user_detail_teacher_color_editor.dart';

class UserDetailTeacherInfo extends ConsumerWidget {
  final User user;

  const UserDetailTeacherInfo({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      children: [
        UserDetailTeacherColorEditor(user: user),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 24),
        const Text("강사 유저 데이터 삭제", style: titleLarge),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => showTerminate(context, ref),
          style: FilledButton.styleFrom(backgroundColor: red),
          child: const Text("삭제"),
        ),
      ],
    );
  }

  Future<void> showTerminate(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text("강사의 유저 데이터를 삭제하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    final isConfirmedAgain = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text("강사 데이터를 삭제합니다"),
        SizedBox(height: 8),
        Text(
          "되돌릴 수 없습니다",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    if (!isConfirmedAgain) return;

    if (!context.mounted) return;
    await ref
        .read(userStateProvider.notifier)
        .terminateTeacher(user.userID)
        .withLoadingOverlay(context);

    ref.invalidate(userListProvider);

    if (!context.mounted) return;
    context.pop();
  }
}
