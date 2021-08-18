import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solviolin_admin/model/ledger.dart';
import 'package:solviolin_admin/model/user.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GetBuilder<DataController>(
      builder: (controller) {
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            User user = controller.users[index];

            return InkWell(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  child: Column(
                    children: [
                      Text("${user.userName} / ${user.branchName}"),
                      Text(_parsePhoneNumber(user.userPhone)),
                      Text("${_parseStatus(user.status)}" +
                          " / 크레딧: ${user.userCredit}"),
                      Text("결제일: ${_ledgerToString(user.ledgers)}"),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                try {
                  await getUserDetailData(controller.users[index]);
                  Get.toNamed("/user/detail");
                } catch (e) {
                  showErrorMessage(context, e.toString());
                }
              },
            );
          },
        );
      },
    );
  }
}

String _parsePhoneNumber(String phone) {
  int middle = phone.length == 10 ? 6 : 7;

  return phone.substring(0, 3) +
      "-" +
      phone.substring(3, middle) +
      "-" +
      phone.substring(middle);
  //NumberFormat("###-####-####").format(number)
}

String _parseStatus(int status) {
  Map<int, String> _status = {
    0: "등록",
    1: "미등록",
  };

  return _status[status]!;
}

String _ledgerToString(List<Ledger> ledgers) => ledgers.length == 0
    ? "결제 기록 없음"
    : DateFormat("yy/MM/dd HH:mm").format(ledgers[0].paidAt);
