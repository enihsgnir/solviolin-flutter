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
import 'package:solviolin/view/loading_page.dart';
import 'package:solviolin/view/login_page.dart';
import 'package:solviolin/view/make_up/make_up_page.dart';
import 'package:solviolin/view/manage/manage_page.dart';
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
      title: "SolViolin",
      theme: theme.copyWith(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
        textTheme: GoogleFonts.nanumGothicTextTheme(theme.textTheme),
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
        GetPage(name: "/manage", page: () => ManagePage()),
        GetPage(name: "/make-up", page: () => MakeUpPage()),
        GetPage(name: "/check-in", page: () => CheckInPage()),
        GetPage(name: "/metronome", page: () => MetronomePage()),
      ],
    );
  }
}
