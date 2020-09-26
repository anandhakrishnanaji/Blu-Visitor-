import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';

import './pages/homePage.dart';
import './pages/addVisitorType.dart';

void main() {
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {
    50: Color.fromRGBO(80, 0, 255, .1),
    100: Color.fromRGBO(80, 0, 255, .2),
    200: Color.fromRGBO(80, 0, 255, .3),
    300: Color.fromRGBO(80, 0, 255, .4),
    400: Color.fromRGBO(80, 0, 255, .5),
    500: Color.fromRGBO(80, 0, 255, .6),
    600: Color.fromRGBO(80, 0, 255, .7),
    700: Color.fromRGBO(80, 0, 255, .8),
    800: Color.fromRGBO(80, 0, 255, .9),
    900: Color.fromRGBO(80, 0, 255, 1),
  };
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF2962FF, color);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Blu Visitor App',
      theme: ThemeData(
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Home(),
      routes: {
        VisitorType.routeName: (ctx) => VisitorType(),
      },
    );
  }
}
