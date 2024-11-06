import 'dart:async';

import 'package:flutter/widgets.dart';

class MetronomeBpmButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const MetronomeBpmButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<MetronomeBpmButton> createState() => _MetronomeBpmButtonState();
}

class _MetronomeBpmButtonState extends State<MetronomeBpmButton> {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void start() {
    timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      widget.onPressed();
    });
  }

  void stop() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onLongPressStart: (details) => start(),
      onLongPressEnd: (details) => stop(),
      child: widget.child,
    );
  }
}
