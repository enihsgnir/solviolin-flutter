import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/widget/dialog.dart';
import 'package:solviolin/widget/single.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var _client = Get.find<Client>();
  var _data = Get.find<DataController>();

  bool hasShownMetronomeNotice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menu("나의 예약", () {
                showLoading(() async {
                  try {
                    await _data.getReservedHistoryData();
                    Get.toNamed("/manage");
                  } catch (e) {
                    showError(e);
                  }
                });
              }),
              menu("수업변경", () {
                showLoading(() async {
                  try {
                    await _data.getSelectedDayData(DateTime.now());
                    await _data.getChangedPageData(DateTime.now());
                    Get.toNamed("/make-up");
                  } catch (e) {
                    showError(e);
                  }
                });
              }),
              menu("QR 체크인", () => Get.toNamed("/check-in")),
              menu("메트로놈", () async {
                Get.toNamed("/metronome");
                if (!hasShownMetronomeNotice) {
                  await showMySnackbar(
                    title: "안내",
                    message: "메트로놈 작동 후 처음 3초 동안은 재생이 원활하지 않을 수 있습니다.",
                  );
                  hasShownMetronomeNotice = true;
                }
              }),
              menu("로그아웃", _showLogout, true),
            ]
                .map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.r),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future _showLogout() {
    return showMyModal(
      context: context,
      message: "로그아웃 하시겠습니까?",
      child: "로그아웃",
      isDestructiveAction: true,
      onPressed: () => showLoading(() async {
        try {
          try {
            _data.reset();
            await _client.logout();
          } catch (_) {
            rethrow;
          } finally {
            Get.offAllNamed("/login");
          }
        } catch (e) {
          if (e is NetworkException && e.isTimeout) {
            showError(e);
          }
        } finally {
          await showMySnackbar(message: "안전하게 로그아웃 되었습니다.");
        }
      }),
    );
  }
}
