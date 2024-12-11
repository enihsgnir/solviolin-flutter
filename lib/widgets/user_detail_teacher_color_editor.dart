import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/models/user.dart';
import 'package:solviolin/providers/client_state/user_state_provider.dart';
import 'package:solviolin/providers/teacher_info_list_provider.dart';
import 'package:solviolin/providers/teacher_info_provider.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/loading_overlay.dart';

class UserDetailTeacherColorEditor extends ConsumerStatefulWidget {
  final User user;

  const UserDetailTeacherColorEditor({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<UserDetailTeacherColorEditor> createState() =>
      _UserDetailTeacherColorEditorState();
}

class _UserDetailTeacherColorEditorState
    extends ConsumerState<UserDetailTeacherColorEditor> {
  Color currentColor = Colors.white;
  Color pickerColor = Colors.white;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      teacherInfoProvider(widget.user),
      (previous, next) {
        setState(() {
          currentColor = next.valueOrNull?.color ?? Colors.white;
          pickerColor = currentColor;
        });
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // remove input decoration theme to prevent text fields of color picker
        // from being styled
        inputDecorationTheme: const InputDecorationTheme(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text("강사 현재 색상", style: titleLarge),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Row(
              children: [
                ColorIndicator(HSVColor.fromColor(currentColor)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: ColorPickerInput(
                      currentColor,
                      (value) {},
                      enableAlpha: false,
                      embeddedText: true,
                      disable: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("색상 변경", style: titleLarge),
          const SizedBox(height: 12),
          TextFieldTapRegion(
            // wrap the color picker in a tap region to unfocus the text field
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            child: HueRingPicker(
              pickerColor: pickerColor,
              onColorChanged: (value) => pickerColor = value,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: showUpdate,
              child: const Text("변경"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showUpdate() async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("색상을 변경하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!mounted) return;
    await ref
        .read(userStateProvider.notifier)
        .update(widget.user.userID, color: pickerColor)
        .withLoadingOverlay(context);

    ref.invalidate(teacherInfoListProvider);

    if (!mounted) return;
    context.pop();
  }
}
