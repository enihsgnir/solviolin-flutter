import 'package:flutter/material.dart';
import 'package:solviolin_common/utils/theme.dart';

class CreditDeductionSelectField extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const CreditDeductionSelectField({
    super.key,
    required this.onChanged,
  });

  @override
  State<CreditDeductionSelectField> createState() =>
      _CreditDeductionSelectFieldState();
}

class _CreditDeductionSelectFieldState
    extends State<CreditDeductionSelectField> {
  bool deductCredit = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                deductCredit = false;
              });
              widget.onChanged(false);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: !deductCredit ? blue : black,
              side: BorderSide(
                color: !deductCredit ? blue : gray600,
              ),
            ),
            child: const Text("미차감"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                deductCredit = true;
              });
              widget.onChanged(true);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: deductCredit ? blue : black,
              side: BorderSide(
                color: deductCredit ? blue : gray600,
              ),
            ),
            child: const Text("차감"),
          ),
        ),
      ],
    );
  }
}
