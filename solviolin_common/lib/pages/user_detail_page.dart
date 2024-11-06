import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/user_type.dart';
import 'package:solviolin_common/providers/user_provider.dart';
import 'package:solviolin_common/widgets/status_widget.dart';
import 'package:solviolin_common/widgets/user_detail_student_info.dart';
import 'package:solviolin_common/widgets/user_detail_teacher_info.dart';

class UserDetailPage extends ConsumerWidget {
  final String userID;

  const UserDetailPage({
    super.key,
    required this.userID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(userID));

    final child = user.when(
      data: (data) {
        return switch (data.userType) {
          UserType.student => UserDetailStudentInfo(user: data),
          UserType.teacher => UserDetailTeacherInfo(user: data),
          UserType.admin => const EmptyStatusWidget(title: "관리자 상세 페이지 준비 중"),
        };
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "유저 정보를 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("$userID 상세 정보"),
        actions: [
          TextButton(
            onPressed: () =>
                context.push("/admin/user/search/result/$userID/update"),
            child: const Text("수정"),
          ),
        ],
      ),
      body: child,
    );
  }
}
