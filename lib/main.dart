import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sidekick_app/view/onboarding/onboarding_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
        (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: const OnBoardingScreen(),
    );
  }
}
