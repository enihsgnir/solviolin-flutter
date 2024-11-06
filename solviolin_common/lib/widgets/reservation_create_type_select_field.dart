import 'package:flutter/material.dart';
import 'package:solviolin_common/models/reservation_create_type.dart';
import 'package:solviolin_common/utils/theme.dart';

class ReservationCreateTypeSelectField extends StatefulWidget {
  final ValueChanged<ReservationCreateType> onChanged;

  const ReservationCreateTypeSelectField({
    super.key,
    required this.onChanged,
  });

  @override
  State<ReservationCreateTypeSelectField> createState() =>
      _ReservationCreateTypeSelectFieldState();
}

class _ReservationCreateTypeSelectFieldState
    extends State<ReservationCreateTypeSelectField> {
  bool regular = true;
  bool makeUp = false;
  bool free = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                regular = true;
                makeUp = false;
                free = false;
              });
              widget.onChanged(ReservationCreateType.regular);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: regular ? blue : black,
              side: BorderSide(
                color: regular ? blue : gray600,
              ),
            ),
            child: const Text("정기 등록"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                makeUp = true;
                regular = false;
                free = false;
              });
              widget.onChanged(ReservationCreateType.makeUp);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: makeUp ? blue : black,
              side: BorderSide(
                color: makeUp ? blue : gray600,
              ),
            ),
            child: const Text("보강 예약"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                free = true;
                regular = false;
                makeUp = false;
              });
              widget.onChanged(ReservationCreateType.free);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: free ? blue : black,
              side: BorderSide(
                color: free ? blue : gray600,
              ),
            ),
            child: const Text("무료 보강"),
          ),
        ),
      ],
    );
  }
}
