import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import './pages/homePage.dart';
import './pages/addVisitorType.dart';
import './pages/languagePage.dart';
import './pages/loginPage.dart';
import 'providers/auth.dart';
import './pages/cameraScreen.dart';
import './pages/addFlatsPage.dart';
import './pages/addPropertiesPage.dart';
import './pages/addVisitorForm.dart';
import './pages/selectCompanyPage.dart';

List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final CameraDescription firstCamera = cameras.first;
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('hi', 'IN')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: MyApp(firstCamera)),
  );
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;
  MyApp(this.camera);
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

    return ChangeNotifierProvider(
      create: (_) => Auth(),
      child: Consumer<Auth>(
        builder: (context, value, child) => MaterialApp(
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
          routes: {
            "/": (ctx) => FutureBuilder(
                future: value.isloggedin(),
                builder: (_, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Scaffold()
                        : (snapshot.data != null && snapshot.data)
                            ? Home()
                            : LoginPage()),
            Home.routeName: (ctx) => Home(),
            VisitorType.routeName: (ctx) => VisitorType(),
            LanguagePage.routeName: (ctx) => LanguagePage(),
            CameraScreen.routeName: (ctx) => CameraScreen(widget.camera),
            AddFlats.routeName: (ctx) => AddFlats(),
            AddProperties.routeName: (ctx) => AddProperties(),
            SelectCompany.routeName: (ctx) => SelectCompany(),
            AddVisitorForm.routeName:(ctx)=>AddVisitorForm()
          },
        ),
      ),
    );
  }
}
