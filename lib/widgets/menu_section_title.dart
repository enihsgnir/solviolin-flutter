import 'package:flutter/material.dart';
import 'package:solviolin/utils/theme.dart';

class MenuSectionTitle extends StatelessWidget {
  final String title;

  const MenuSectionTitle(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleMedium),
          const Divider(),
        ],
      ),
    );
  }
}
