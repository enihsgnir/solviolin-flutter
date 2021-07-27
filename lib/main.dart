import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solviolin/page/history_page.dart';
import 'package:solviolin/page/loading_page.dart';
import 'package:solviolin/page/login_page.dart';
import 'package:solviolin/page/main_page.dart';
import 'package:solviolin/page/metronome_page.dart';
import 'package:solviolin/page/qrcode_scan_page.dart';
import 'package:solviolin/page/test_page.dart';
import 'package:solviolin/util/controller.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(MyApp());
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
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // systemNavigationBarColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DataController());
    return GetMaterialApp(
      title: "SolViolin",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        textTheme: GoogleFonts.nanumGothicTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // initialRoute: "/loading",
      initialRoute: "/metronome",
      getPages: [
        GetPage(name: "/loading", page: () => LoadingPage()),
        GetPage(name: "/login", page: () => LoginPage()),
        GetPage(name: "/main", page: () => MainPage()),
        GetPage(name: "/history", page: () => HistoryPage()),
        GetPage(name: "/scan", page: () => QRCodeScanPage()),
        GetPage(name: "/metronome", page: () => MetronomePage()),
        GetPage(
          name: "/test",
          page: () => TestPage(),
          transition: Transition.zoom,
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
