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
import 'package:solviolin_admin/view/ledger/ledger_page.dart';
import 'package:solviolin_admin/view/loading_page.dart';
import 'package:solviolin_admin/view/login_page.dart';
import 'package:solviolin_admin/view/main/day_view.dart';
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
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FlutterSecureStorage());
    Get.put(Client());
    Get.put(DataController());

    return GetMaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
        GetPage(name: "/main", page: () => MainPage()),
        GetPage(name: "/main/day", page: () => DayView()),
        GetPage(name: "/menu", page: () => MenuPage()),
        GetPage(name: "/user", page: () => UserPage()),
        GetPage(name: "/user/detail", page: () => UserDetailPage()),
        GetPage(name: "/control", page: () => ControlPage()),
        GetPage(name: "/term", page: () => TermPage()),
        GetPage(name: "/teacher", page: () => TeacherPage()),
        GetPage(name: "/ledger", page: () => LedgerPage()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
