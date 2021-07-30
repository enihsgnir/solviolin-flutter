import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solviolin/network/get_data.dart';
import 'package:solviolin/util/controller.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  await client.getReservations(
                    branchName: "잠실",
                    userID: "sleep",
                    bookingStatus: [-3, -2, -1, 0, 1, 2, 3],
                  );
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
                onPressed: () {
                  print(MediaQuery.of(context).size.height);
                  print(MediaQuery.of(context).size.width);
                  print(MediaQuery.of(context).padding);
                  print(MediaQuery.of(context).viewPadding);
                  print(MediaQuery.of(context).viewInsets);
                  print(MediaQuery.of(context).devicePixelRatio);
                  print(MediaQuery.of(context).textScaleFactor);
                },
                child: Text(
                  "Print",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextField(),
              TextButton(
                onPressed: () {
                  Get.toNamed("/metronome");
                },
                child: Text(
                  "Metronome",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
