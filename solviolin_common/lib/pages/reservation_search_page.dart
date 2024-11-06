import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/extensions/null_if_empty_extension.dart';
import 'package:solviolin_common/providers/form/reservation_search_form_provider.dart';
import 'package:solviolin_common/widgets/branch_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/teacher_id_select_field.dart';

class ReservationSearchPage extends ConsumerStatefulWidget {
  const ReservationSearchPage({super.key});

  @override
  ConsumerState<ReservationSearchPage> createState() =>
      _ReservationSearchPageState();
}

class _ReservationSearchPageState extends ConsumerState<ReservationSearchPage> {
  late String branchName;
  String? teacherID;
  final userIDController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final form = ref.read(reservationSearchFormProvider);
    branchName = form.branchName;
    teacherID = form.teacherID;
    userIDController.text = form.userID ?? "";
  }

  @override
  void dispose() {
    userIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = branchName.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("수업 검색"),
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
            initialValue: branchName,
            onChanged: (value) => setState(() => branchName = value),
          ),
          const FormTitle("강사"),
          TeacherIDSelectField(
            branchName: branchName,
            initialValue: teacherID,
            onChanged: (value) => teacherID = value.nullIfEmpty,
          ),
          const FormTitle("수강생 아이디"),
          TextField(
            controller: userIDController,
            decoration: const InputDecoration(
              hintText: "수강생 아이디를 입력하세요",
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () {
                    final userID = userIDController.text;

                    ref.read(reservationSearchFormProvider.notifier).search(
                          branchName: branchName,
                          teacherID: teacherID,
                          userID: userID.nullIfEmpty,
                        );

                    context.pop();
                  }
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
