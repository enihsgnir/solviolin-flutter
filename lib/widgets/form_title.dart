import 'package:flutter/widgets.dart';
import 'package:solviolin/utils/theme.dart';

class FormTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  const FormTitle(
    this.title, {
    super.key,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRequiredText = isRequired ? " (필수)" : " (선택)";
    final isRequiredColor = isRequired ? red : gray600;

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: title, style: titleLarge),
            TextSpan(
              text: isRequiredText,
              style: bodyLarge.copyWith(color: isRequiredColor),
            ),
          ],
        ),
      ),
    );
  }
}
