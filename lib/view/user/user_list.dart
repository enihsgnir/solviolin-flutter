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
  DetailController detail = Get.put(DetailController());

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
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 4.r,
                  horizontal: 8.r,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.r,
                  ),
                  child: Column(
                    children: [
                      Text("${user.userName} / ${user.branchName}"),
                      Text(_parsePhoneNumber(user.userPhone)),
                      Text("${_statusToString(user.status)}" +
                          " / 크레딧: ${user.userCredit}"),
                      Text("결제일: ${_ledgerToString(user.ledgers)}"),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                try {
                  await getUserDetailData(user);
                  detail.updateUser(user);
                  Get.toNamed("/user/detail");
                } catch (e) {
                  showError(context, e.toString());
                }
              },
            );
          },
        );
      },
    );
  }

  String _parsePhoneNumber(String phone) {
    if (phone.length == 10) {
      return phone.replaceAllMapped(
        RegExp(r"(\d{3})(\d{3})(\d+)"),
        (match) => "${match[1]}-${match[2]}-${match[3]}",
      );
    } else if (phone.length == 11) {
      return phone.replaceAllMapped(
        RegExp(r"(\d{3})(\d{4})(\d+)"),
        (match) => "${match[1]}-${match[2]}-${match[3]}",
      );
    } else if (phone.length > 3) {
      return phone.replaceAllMapped(
        RegExp(r"(\d{3})(\d+)"),
        (match) => "${match[1]}-${match[2]}",
      );
    } else {
      return phone;
    }
  }

  String _statusToString(int status) {
    Map<int, String> _status = {
      0: "미등록",
      1: "등록",
    };

    return _status[status]!;
  }

  String _ledgerToString(List<Ledger> ledgers) => ledgers.length == 0
      ? "결제 기록 없음"
      : DateFormat("yy/MM/dd HH:mm").format(ledgers[0].paidAt);
}
