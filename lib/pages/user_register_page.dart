import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/user_register_form_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/loading_overlay.dart';
import 'package:solviolin/widgets/user_type_select_field.dart';

class UserRegisterPage extends ConsumerWidget {
  const UserRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      userRegisterFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("유저 신규 등록"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const FormTitle("아이디", isRequired: true),
          TextField(
            decoration: const InputDecoration(
              hintText: "아이디를 입력하세요",
            ),
            onChanged: (value) =>
                ref.read(userRegisterFormProvider.notifier).setUserID(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("비밀번호", isRequired: true),
          TextField(
            decoration: const InputDecoration(
              hintText: "비밀번호를 입력하세요",
            ),
            obscureText: true,
            onChanged: (value) => ref
                .read(userRegisterFormProvider.notifier)
                .setUserPassword(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("이름", isRequired: true),
          TextField(
            decoration: const InputDecoration(
              hintText: "이름를 입력하세요",
            ),
            onChanged: (value) =>
                ref.read(userRegisterFormProvider.notifier).setUserName(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("전화번호", isRequired: true),
          TextField(
            decoration: const InputDecoration(
              hintText: "전화번호를 입력하세요 (하이픈 '-' 제외)",
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) =>
                ref.read(userRegisterFormProvider.notifier).setUserPhone(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("지점명", isRequired: true),
          BranchSelectField(
            onChanged: (value) => ref
                .read(userRegisterFormProvider.notifier)
                .setUserBranch(value),
          ),
          const FormTitle("유저 구분", isRequired: true),
          UserTypeSelectField(
            onChanged: (value) =>
                ref.read(userRegisterFormProvider.notifier).setUserType(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled ? () => showRegister(context, ref) : null,
            child: const Text("등록"),
          ),
        ],
      ),
    );
  }

  Future<void> showRegister(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: [
        const Text("신규 유저를 등록하시겠습니까?"),
        const SizedBox(height: 8),
        const Text("아이디는 등록 후 변경할 수 없습니다."),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(userRegisterFormProvider.notifier)
        .submit()
        .withLoadingOverlay(context);

    if (!context.mounted) return;
    context.pop();
  }
}
