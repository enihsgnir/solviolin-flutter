import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/data_source.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/main/time_slot.dart';
import 'package:solviolin_admin/widget/selection.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Client client = Get.find<Client>();
  DataController _controller = Get.find<DataController>();

  TextEditingController user = TextEditingController();
  TextEditingController teacher = TextEditingController();
  BranchController branch = Get.put(BranchController());

  SearchController search = Get.find<SearchController>(tag: "Main");

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    user.dispose();
    teacher.dispose();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar(
          "메인",
          actions: [
            Container(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                child: Icon(CupertinoIcons.slider_horizontal_3),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black26,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: AlertDialog(
                          title: Text(
                            "검색",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: input(
                                  "수강생",
                                  user,
                                  "이름을 입력하세요!",
                                  true,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: input(
                                  "강사",
                                  teacher,
                                  "강사명을 입력하세요!",
                                  true,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                child: branchDropdown(null, "지점을 선택하세요!"),
                              ),
                            ],
                          ),
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 12),
                              ),
                              child: Text(
                                "취소",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: branch.branchName == null
                                  ? () {
                                      showErrorMessage(
                                          context, "필수 입력값을 확인하세요!");
                                    }
                                  : () async {
                                      try {
                                        await getReservationData(
                                          focusedDay: _controller.selectedDay,
                                          branchName: branch.branchName!,
                                          userID: user.text,
                                          teacherID: teacher.text == ""
                                              ? null
                                              : teacher.text,
                                        );
                                        Get.back();
                                        search.isSearched = true;
                                      } catch (e) {
                                        showErrorMessage(context, e.toString());
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromRGBO(96, 128, 104, 100),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 12),
                              ),
                              child: Text(
                                "등록",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: GetBuilder<DataController>(
            builder: (controller) {
              return Container(
                height: double.infinity,
                child: TimeSlot(),
              );
            },
          ),
        ),
      ),
    );
  }
}
