import 'package:flutter/material.dart';
import 'package:solviolin/models/payment_status.dart';
import 'package:solviolin/utils/theme.dart';

class PaymentStatusMultiSelectField extends StatefulWidget {
  final bool enabled;
  final ValueChanged<PaymentStatus?> onChanged;

  const PaymentStatusMultiSelectField({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  State<PaymentStatusMultiSelectField> createState() =>
      _PaymentStatusMultiSelectFieldState();
}

class _PaymentStatusMultiSelectFieldState
    extends State<PaymentStatusMultiSelectField> {
  bool isNotPaid = false;
  bool isPaid = true;

  void onPressed() {
    if (isNotPaid && isPaid) {
      widget.onChanged(null);
    } else if (isNotPaid) {
      widget.onChanged(PaymentStatus.isNotPaid);
    } else if (isPaid) {
      widget.onChanged(PaymentStatus.isPaid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.enabled
                ? () {
                    setState(() {
                      isNotPaid = !isNotPaid;
                      if (!isNotPaid && !isPaid) {
                        isPaid = true;
                      }
                    });
                    onPressed();
                  }
                : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: isNotPaid ? blue : black,
              side: BorderSide(
                color: widget.enabled && isNotPaid ? blue : gray600,
              ),
            ),
            child: const Text("미결제"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: widget.enabled
                ? () {
                    setState(() {
                      isPaid = !isPaid;
                      if (!isNotPaid && !isPaid) {
                        isNotPaid = true;
                      }
                    });
                    onPressed();
                  }
                : null,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: isPaid ? blue : black,
              side: BorderSide(
                color: widget.enabled && isPaid ? blue : gray600,
              ),
            ),
            child: const Text("결제"),
          ),
        ),
      ],
    );
  }
}
