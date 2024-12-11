import 'package:flutter/widgets.dart';
import 'package:solviolin/utils/theme.dart';

class ResultCount extends StatelessWidget {
  final int count;

  const ResultCount(
    this.count, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: RichText(
        text: TextSpan(
          style: titleSmall,
          children: [
            const TextSpan(text: "검색결과 "),
            TextSpan(
              text: "$count",
              style: const TextStyle(color: green),
            ),
          ],
        ),
      ),
    );
  }
}
