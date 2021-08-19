import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/view/for_teacher_profile.dart/time_slot_for_teacher.dart';
import 'package:solviolin_admin/widget/single_reusable.dart';

class MainForTeacherPage extends StatefulWidget {
  const MainForTeacherPage({Key? key}) : super(key: key);

  @override
  _MainForTeacherPageState createState() => _MainForTeacherPageState();
}

class _MainForTeacherPageState extends State<MainForTeacherPage> {
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<DataController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar("메인"),
        body: SafeArea(
          child: GetBuilder<DataController>(
            builder: (controller) {
              return Container(
                height: double.infinity,
                child: TimeSlotForTeacher(),
              );
            },
          ),
        ),
      ),
    );
  }
}
