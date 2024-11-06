import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/user.dart';
import 'package:solviolin_common/providers/user_list_provider.dart';
import 'package:solviolin_common/utils/downloads.dart';
import 'package:solviolin_common/utils/excel.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/custom_snack_bar.dart';

class UserListSaveButton extends ConsumerStatefulWidget {
  const UserListSaveButton({super.key});

  @override
  ConsumerState<UserListSaveButton> createState() => _UserListSaveButtonState();
}

class _UserListSaveButtonState extends ConsumerState<UserListSaveButton> {
  Widget icon = const Icon(Icons.download_rounded);
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(userListProvider).valueOrNull ?? [];

    return IconButton(
      onPressed: userList.isEmpty || isDownloading
          ? null
          : () => showSaveUserList(userList),
      icon: icon,
    );
  }

  Future<void> showSaveUserList(List<User> userList) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("유저 목록을 저장 하시겠습니까?"),
        SizedBox(height: 8),
        Text("다운로드한 파일은 엑셀 파일로 저장됩니다"),
      ],
    );

    if (!isConfirmed) return;

    setState(() {
      icon = const Icon(Icons.downloading_rounded);
      isDownloading = true;
    });

    try {
      final sortedUserList = [...userList]
        ..sort((a, b) => a.userName.compareTo(b.userName));

      final bytes = saveExcel([
        ["이름", "전화번호"],
        for (final user in sortedUserList)
          [user.userName, user.userPhone.format(phoneNumber)],
      ]);

      final timeStamp = getTimeStamp();
      await saveDownloads(
        basename: "solviolin_user_list_$timeStamp",
        extension: "xlsx",
        bytes: bytes,
      );

      setState(() {
        icon = const Icon(Icons.download_done);
        isDownloading = false;
      });

      if (!mounted) return;
      showCustomSnackBar(
        context,
        message: "다운로드 폴더에 저장했습니다",
        action: const SnackBarAction(
          label: "열기",
          onPressed: openDownloads,
        ),
      );
    } catch (e) {
      setState(() {
        icon = const Icon(Icons.download_rounded);
        isDownloading = false;
      });

      if (!mounted) return;
      showCustomSnackBar(context, message: "다운로드에 실패했습니다");
    }
  }
}
