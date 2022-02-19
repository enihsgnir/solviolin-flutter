import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/model/reservation.dart';
import 'package:solviolin_admin/util/constant.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/format.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/widget/dialog.dart';
import 'package:solviolin_admin/widget/input.dart';
import 'package:solviolin_admin/widget/item_list.dart';

class HistoryReserved extends StatefulWidget {
  final List<Reservation> reservations;

  const HistoryReserved(
    this.reservations, {
    Key? key,
  }) : super(key: key);

  @override
  _HistoryReservedState createState() => _HistoryReservedState();
}

class _HistoryReservedState extends State<HistoryReserved> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  var search = Get.find<CacheController>(tag: "/search/user");

  @override
  Widget build(BuildContext context) {
    return widget.reservations.isEmpty
        ? DefaultTextStyle(
            style: TextStyle(color: Colors.red, fontSize: 20.r),
            textAlign: TextAlign.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("예약 내역을 조회할 수 없습니다."),
              ],
            ),
          )
        : ListView.builder(
            itemCount: widget.reservations.length,
            itemBuilder: (context, index) {
              var reservation = widget.reservations[index];

              return mySlidableCard(
                slideActions: [
                  mySlideAction(
                    context: context,
                    icon: CupertinoIcons.delete_left,
                    item: "취소",
                    onTap: () async {
                      reservation.startDate.isBefore(DateTime.now())
                          ? await showError("지난 수업은 취소할 수 없습니다.")
                          : reservation.bookingStatus.abs() == 2
                              ? await showError("이미 취소된 수업입니다.")
                              : await _showCancelByAdmin(reservation);
                    },
                    borderRight: true,
                  ),
                  mySlideAction(
                    context: context,
                    icon: Icons.more_time,
                    item: "연장",
                    onTap: () async {
                      reservation.startDate.isBefore(DateTime.now())
                          ? await showError("지난 수업은 연장할 수 없습니다.")
                          : reservation.bookingStatus.abs() == 3
                              ? await showError("이미 연장된 수업입니다.")
                              : reservation.bookingStatus.abs() == 2
                                  ? await showError("취소된 수업은 연장할 수 없습니다.")
                                  : await _showExtendByAdmin(reservation);
                    },
                    borderLeft: true,
                    borderRight: true,
                  ),
                  mySlideAction(
                    context: context,
                    icon: Icons.delete_forever,
                    item: "삭제",
                    onTap: () async {
                      await _showDelete(reservation);
                    },
                    borderLeft: true,
                  ),
                ],
                children: [
                  Text(
                    reservation.toString(),
                    style: TextStyle(
                      decoration: reservation.bookingStatus.abs() == 2
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 24.r),
                    width: double.infinity,
                    child: Text(
                      reservation.statusToString,
                      style: TextStyle(color: Colors.red, fontSize: 20.r),
                    ),
                  ),
                ],
              );
            },
          );
  }

  Future _showCancelByAdmin(Reservation reservation) {
    var deductCredit = false;

    return showMyDialog(
      title: "취소 (관리자)",
      contents: [
        Text(formatDateTime(reservation.startDate) + " ~\n수업을 취소 하시겠습니까?"),
        Row(
          children: [
            label("크레딧 차감", true),
            StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: deductCredit,
                  onChanged: (value) {
                    setState(() {
                      deductCredit = value!;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.cancelReservationByAdmin(
            reservation.id,
            deductCredit: deductCredit,
          );

          await _getSearchedUsersData();
          Get.back();

          await showMySnackbar(
            message:
                "관리자의 권한으로 크레딧을 ${deductCredit ? "차감" : "미차감"}하여 수업을 취소했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
    );
  }

  Future _showExtendByAdmin(Reservation reservation) {
    var deductCredit = false;

    return showMyDialog(
      title: "연장 (관리자)",
      contents: [
        Text(formatDateTime(reservation.startDate) + " ~\n수업을 15분 연장 하시겠습니까?"),
        Row(
          children: [
            label("크레딧 차감", true),
            StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: deductCredit,
                  onChanged: (value) {
                    setState(() {
                      deductCredit = value!;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ],
      onPressed: () => showLoading(() async {
        try {
          await _client.extendReservationByAdmin(
            reservation.id,
            deductCredit: deductCredit,
          );

          await _getSearchedUsersData();
          Get.back();

          await showMySnackbar(
            message:
                "관리자의 권한으로 크레딧을 ${deductCredit ? "차감" : "미차감"}하여 수업을 연장했습니다.",
          );
        } catch (e) {
          showError(e);
        }
      }),
    );
  }

  Future _showDelete(Reservation reservation) {
    return showMyDialog(
      contents: [
        Text(formatDateTime(reservation.startDate) +
            " ~\n예약을 삭제하시겠습니까?" +
            "\n취소 내역에 기록되지 않습니다."),
        Text(
          "\n*되돌릴 수 없습니다.*" +
              "\n\n*취소와는 다른 기능입니다.*" +
              "\n\n*강제로 예약 데이터를 삭제합니다.\n예상치 못한 오류가 발생할 수 있습니다.*" +
              "\n\n*잘못 예약했을 경우 즉시 철회하는\n용도로만 사용하는 것을 권장합니다.*",
          style: TextStyle(color: Colors.red),
        ),
      ],
      onPressed: () {
        showMyDialog(
          contents: [
            Text(
              "정말로 삭제하시겠습니까?",
              style: TextStyle(color: Colors.red),
            ),
          ],
          onPressed: () => showLoading(() async {
            try {
              await _client.deleteReservation(reservation.id);

              await _getSearchedUsersData();
              Get.until(ModalRoute.withName("/user/detail"));
              await showMySnackbar(message: "예약을 삭제했습니다.");
            } catch (e) {
              showError(e);
            }
          }),
        );
      },
      isScrollable: true,
    );
  }

  Future<void> _getSearchedUsersData() async {
    await _data.getUsersData(
      branchName: search.branchName,
      userID: textEdit(search.edit1),
      isPaid: search.check[0],
      userType: search.userType?.index,
      status: search.check[1],
      termID: search.termID,
    );
    await _data.getUserDetailData(search.userDetail!);
  }
}
