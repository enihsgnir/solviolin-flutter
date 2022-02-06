import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solviolin/util/controller.dart';
import 'package:solviolin/util/network.dart';
import 'package:solviolin/view/check_in_page.dart';
import 'package:solviolin/view/history/history_page.dart';
import 'package:solviolin/view/loading_page.dart';
import 'package:solviolin/view/login_page.dart';
import 'package:solviolin/view/main/main_page.dart';
import 'package:solviolin/view/menu_page.dart';
import 'package:solviolin/view/metronome_page.dart';

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
  Widget build(BuildContext context) {
    Get.put(FlutterSecureStorage());
    Get.put(Client());
    var _data = Get.put(DataController());

    return GetMaterialApp(
      builder: (context, child) {
        if (!_data.isRatioUpdated) {
          var _ratio = min(MediaQuery.of(context).size.width / 540,
              MediaQuery.of(context).size.height / 1152);
          if (_ratio != 0.0) {
            _data.ratio = _ratio;
            _data.isRatioUpdated = true;
            _data.update();
          }
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: min(MediaQuery.of(context).textScaleFactor, 1.0),
          ),
          child: child!,
        );
      },
      title: "SolViolin",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
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
        GetPage(name: "/history", page: () => HistoryPage()),
        GetPage(name: "/check-in", page: () => CheckInPage()),
        GetPage(name: "/metronome", page: () => MetronomePage()),
      ],
    );
  }
}
