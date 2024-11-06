import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/canceled_page.dart';
import 'package:solviolin_admin/view/check_in/check_in_history_page.dart';
import 'package:solviolin_admin/view/check_in/check_in_page.dart';
import 'package:solviolin_admin/view/control_page.dart';
import 'package:solviolin_admin/view/for_teacher/canceled_for_teacher_page.dart';
import 'package:solviolin_admin/view/for_teacher/control_for_teacher_page.dart';
import 'package:solviolin_admin/view/for_teacher/main_for_teacher_page.dart';
import 'package:solviolin_admin/view/for_teacher/menu_for_teacher_page.dart';
import 'package:solviolin_admin/view/ledger_page.dart';
import 'package:solviolin_admin/view/loading_page.dart';
import 'package:solviolin_admin/view/login_page.dart';
import 'package:solviolin_admin/view/main/main_page.dart';
import 'package:solviolin_admin/view/menu_page.dart';
import 'package:solviolin_admin/view/salary_page.dart';
import 'package:solviolin_admin/view/teacher_page.dart';
import 'package:solviolin_admin/view/term_page.dart';
import 'package:solviolin_admin/view/user_page.dart';
import 'package:solviolin_admin/view/user_detail/user_detail_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    Get.put(FlutterSecureStorage());
    Get.put(Client());
    var _data = Get.put(DataController());

    return GetMaterialApp(
      builder: (context, child) {
        _data.size = MediaQuery.of(context).size;

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: min(MediaQuery.of(context).textScaleFactor, 1.0),
          ),
          child: child!,
        );
      },
      title: "SolViolin_Admin",
      theme: theme.copyWith(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: "/loading",
      getPages: [
        GetPage(name: "/loading", page: () => LoadingPage()),
        GetPage(name: "/login", page: () => LoginPage()),
        GetPage(name: "/menu", page: () => MenuPage()),
        GetPage(name: "/main", page: () => MainPage()),
        GetPage(name: "/user", page: () => UserPage()),
        GetPage(name: "/user/detail", page: () => UserDetailPage()),
        GetPage(name: "/term", page: () => TermPage()),
        GetPage(name: "/ledger", page: () => LedgerPage()),
        GetPage(name: "/teacher", page: () => TeacherPage()),
        GetPage(name: "/control", page: () => ControlPage()),
        GetPage(name: "/teacher/canceled", page: () => CanceledPage()),
        GetPage(name: "/teacher/salary", page: () => SalaryPage()),
        GetPage(name: "/check-in", page: () => CheckInPage()),
        GetPage(name: "/check-in/history", page: () => CheckInHistoryPage()),
        GetPage(name: "/menu-teacher", page: () => MenuForTeacherPage()),
        GetPage(name: "/main-teacher", page: () => MainForTeacherPage()),
        GetPage(name: "/control-teacher", page: () => ControlForTeacherPage()),
        GetPage(
            name: "/canceled-teacher", page: () => CanceledForTeacherPage()),
      ],
    );
  }
}
