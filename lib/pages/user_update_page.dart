import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/providers/form/user_update_form_provider.dart';
import 'package:solviolin/providers/user_list_provider.dart';
import 'package:solviolin/providers/user_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/loading_overlay.dart';
import 'package:solviolin/widgets/user_status_select_field.dart';

class UserUpdatePage extends ConsumerWidget {
  final String userID;

  const UserUpdatePage({
    super.key,
    required this.userID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(userID)).valueOrNull;

    final enabled = ref.watch(userUpdateFormProvider.select((value) => true));

    return Scaffold(
      appBar: AppBar(
        title: Text("$userID 유저 정보 수정"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const FormTitle("이름"),
          TextField(
            decoration: InputDecoration(
              hintText: user?.userName ?? "이름을 입력하세요",
            ),
            onChanged: (value) =>
                ref.read(userUpdateFormProvider.notifier).setUserName(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("비밀번호"),
          TextField(
            decoration: const InputDecoration(
              hintText: "비밀번호를 입력하세요",
            ),
            obscureText: true,
            onChanged: (value) => ref
                .read(userUpdateFormProvider.notifier)
                .setUserPassword(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("전화번호"),
          TextField(
            decoration: InputDecoration(
              hintText: user?.userPhone ?? "전화번호를 입력하세요",
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) =>
                ref.read(userUpdateFormProvider.notifier).setUserPhone(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("크레딧"),
          TextField(
            decoration: InputDecoration(
              hintText: user?.userCredit.toString() ?? "크레딧을 입력하세요",
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => ref
                .read(userUpdateFormProvider.notifier)
                .setUserCredit(int.tryParse(value)),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("지점명"),
          BranchSelectField(
            initialValue: user?.branchName,
            onChanged: (value) =>
                ref.read(userUpdateFormProvider.notifier).setUserBranch(value),
          ),
          const FormTitle("등록 여부", isRequired: true),
          UserStatusSelectField(
            initialValue: user?.status ?? UserStatus.registered,
            onChanged: (value) =>
                ref.read(userUpdateFormProvider.notifier).setStatus(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled ? () => showUpdate(context, ref) : null,
            child: const Text("수정하기"),
          ),
        ],
      ),
    );
  }

  Future<void> showUpdate(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("유저 정보를 수정 하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(userUpdateFormProvider.notifier)
        .submit(userID)
        .withLoadingOverlay(context);
    ref.invalidate(userListProvider);

    if (!context.mounted) return;
    context.pop();
  }
}
