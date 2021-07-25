import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/notification.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    Client client = Get.put(Client());
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.blue.shade100,
          child: Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    Get.offAllNamed("/main");
                  },
                  child: Text(
                    "MainPage",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                // TextButton(
                //   onPressed: () async {
                //     await client.registerTeacher();
                //   },
                //   child: Text(
                //     "Register Teacher",
                //     style: TextStyle(fontSize: 40),
                //   ),
                // ),
                // TextButton(
                //   onPressed: () async {
                //     await client.updateUserInformation();
                //   },
                //   child: Text(
                //     "Change Info",
                //     style: TextStyle(fontSize: 40),
                //   ),
                // ),
                TextButton(
                  onPressed: () async {
                    await client.getTeachers(
                        teacherID: "teacher2", branchName: "잠실");
                  },
                  child: Text(
                    "Get Teacher 'teacher2' '잠실'",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await client.getReservations("잠실", userID: "sleep");
                  },
                  child: Text(
                    "Get Reservation '잠실' 'sleep'",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await client.getProfile();
                  },
                  child: Text(
                    "Get Profile",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await client.getRegularSchedules();
                  },
                  child: Text(
                    "Get Regular",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print(Get.find<DataController>().user.branchName);
                  },
                  child: Text(
                    "Print",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await client.refresh();
                  },
                  child: Text(
                    "Refresh",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    modalCancelOrExtend(context);
                  },
                  child: Text(
                    "Dialog",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
