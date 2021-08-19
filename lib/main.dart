import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solviolin_admin/util/controller.dart';
import 'package:solviolin_admin/util/network.dart';
import 'package:solviolin_admin/view/control/control_page.dart';
import 'package:solviolin_admin/view/for_teacher_profile.dart/main_for_teacher_page.dart';
import 'package:solviolin_admin/view/for_teacher_profile.dart/menu_for_teacher_page.dart';
import 'package:solviolin_admin/view/ledger/ledger_page.dart';
import 'package:solviolin_admin/view/loading_page.dart';
import 'package:solviolin_admin/view/login_page.dart';
import 'package:solviolin_admin/view/main/main_page.dart';
import 'package:solviolin_admin/view/menu_page.dart';
import 'package:solviolin_admin/view/teacher/teacher_page.dart';
import 'package:solviolin_admin/view/term/term_page.dart';
import 'package:solviolin_admin/view/user/user_page.dart';
import 'package:solviolin_admin/view/user_detail/user_detail_page.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

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
  DataController _controller = Get.put(DataController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.updateRatio(MediaQuery.of(context).size.height / 1152);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FlutterSecureStorage());
    Get.put(Client());

    return GetMaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          devicePixelRatio: 2,
          textScaleFactor: 1.0,
        ),
        child: child!,
      ),
      title: "SolViolin_Admin",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        textTheme:
            GoogleFonts.nanumGothicTextTheme(Theme.of(context).textTheme),
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
        GetPage(name: "/control", page: () => ControlPage()),
        GetPage(name: "/term", page: () => TermPage()),
        GetPage(name: "/teacher", page: () => TeacherPage()),
        GetPage(name: "/ledger", page: () => LedgerPage()),
        GetPage(name: "/menu-teacher", page: () => MenuForTeacherPage()),
        GetPage(name: "/main-teacher", page: () => MainForTeacherPage()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
