import 'package:flutter/material.dart';
import 'package:solviolin_common/utils/theme.dart';

class EmptyStatusWidget extends StatelessWidget {
  final String title;
  final String? subtitle;

  const EmptyStatusWidget({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;

    final child = subtitle == null
        ? Text(title, style: titleMedium)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: titleMedium),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: bodySmall.copyWith(color: gray600),
              ),
            ],
          );

    return Align(
      alignment: const Alignment(0, -0.5),
      child: child,
    );
  }
}

class LoadingStatusWidget extends StatelessWidget {
  const LoadingStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment(0, -0.5),
      child: CircularProgressIndicator(),
    );
  }
}
