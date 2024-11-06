import 'package:flutter/widgets.dart';
import 'package:solviolin_common/models/check_in.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/utils/theme.dart';

class CheckInListTile extends StatelessWidget {
  final CheckIn checkIn;

  const CheckInListTile(
    this.checkIn, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = checkIn.createdAt.format(dateTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("유저:"),
              Text("${checkIn.branchName} ${checkIn.userID}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("체크인 시각:"),
              Text(createdAt),
            ],
          ),
        ],
      ),
    );
  }
}
