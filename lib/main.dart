import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sidekick_app/providers/auth.dart';
import 'package:sidekick_app/utils/token_storage.dart';
import 'package:sidekick_app/view/auth/signin_screen.dart';
import 'package:sidekick_app/view/onboarding/onboarding_screen.dart';
import 'package:sidekick_app/view/tab_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/first_launch.dart';


Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      ChangeNotifierProvider(
        create: (context) => Auth(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final TokenStorage tokenStorage = TokenStorage();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String _accessToken = "";
  bool isFirstTime = true;

  _loadTokens() async {
    _accessToken = await tokenStorage.getAccessToken() ?? "";
  }

  @override
  void initState() {
    super.initState();
    _loadTokens();
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    isFirstTime = await FirstLaunchUtil.isFirstLaunch();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sidekick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xffF25D29,
          <int, Color>{
            50: Color(0xffF25D29),
            100: Color(0xffF25D29),
            200: Color(0xffF25D29),
            300: Color(0xffF25D29),
            400: Color(0xffF25D29),
            500: Color(0xffF25D29),
            600: Color(0xffF25D29),
            700: Color(0xffF25D29),
            800: Color(0xffF25D29),
            900: Color(0xffF25D29),
          },
        ),
      ),
      locale: const Locale('fr', ''),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''), // Français
      ],
      home: _accessToken != ""
          ? const TabScreen()
          : isFirstTime
              ? const OnBoardingScreen()
              : const SignInScreen(),
    );
    }
}
