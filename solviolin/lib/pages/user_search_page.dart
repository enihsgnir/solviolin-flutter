import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/providers/form/user_search_form_provider.dart';
import 'package:solviolin/providers/term_range_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/payment_status_multi_select_field.dart';
import 'package:solviolin/widgets/term_select_field.dart';
import 'package:solviolin/widgets/user_status_select_field.dart';
import 'package:solviolin/widgets/user_type_select_field.dart';

class UserSearchPage extends ConsumerWidget {
  const UserSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      userSearchFormProvider.select((value) => value.enabled),
    );

    final userType = ref.watch(
      userSearchFormProvider.select((value) => value.userType),
    );

    final currentTerm = ref.watch(termRangeProvider).valueOrNull?.current;

    return Scaffold(
      appBar: AppBar(
        title: const Text("유저 검색"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const FormTitle("지점명", isRequired: true),
          BranchSelectField(
            onChanged: (value) =>
                ref.read(userSearchFormProvider.notifier).setBranchName(value),
          ),
          const FormTitle("유저 구분", isRequired: true),
          UserTypeSelectField(
            onChanged: (value) =>
                ref.read(userSearchFormProvider.notifier).setUserType(value),
          ),
          const FormTitle("등록 여부", isRequired: true),
          UserStatusSelectField(
            onChanged: (value) =>
                ref.read(userSearchFormProvider.notifier).setStatus(value),
          ),
          const FormTitle("학기", isRequired: true),
          TermSelectField(
            initialValue: currentTerm,
            onChanged: (value) =>
                ref.read(userSearchFormProvider.notifier).setTermID(value),
          ),
          const FormTitle("결제 여부"),
          PaymentStatusMultiSelectField(
            enabled: userType == UserType.student,
            onChanged: (value) =>
                ref.read(userSearchFormProvider.notifier).setIsPaid(value),
          ),
          const FormTitle("유저 아이디"),
          TextField(
            decoration: const InputDecoration(
              hintText: "유저 아이디를 입력하세요",
            ),
            onChanged: (value) =>
                ref.read(userSearchFormProvider.notifier).setUserID(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => context.push("/admin/user/search/result")
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
