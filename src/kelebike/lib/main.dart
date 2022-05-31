import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:kelebike/firebase_options.dart';
import 'package:kelebike/screens/admin_screen.dart';
import 'package:kelebike/screens/home_screen.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:kelebike/service/localization_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  BikeService _bikeService = BikeService();
  User? _user = FirebaseAuth.instance.currentUser;
  bool loggedIn = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget startPage = HomeScreen();
    if (_user == null || !_user!.emailVerified) {
      startPage = LoginScreen();
    } else if (_user!.email == "berkaybaygut@gmail.com") {
      startPage = AdminScreen();
    } else {
      startPage = HomeScreen();
    }
    var localizationController = Get.put(LocalizationController());

    return GetBuilder(
        init: localizationController,
        builder: (LocalizationController controller) {
          return MaterialApp(
            title: 'Kelebike',
            debugShowCheckedModeBanner: false,
            home: startPage,
            locale: controller.currentLanguage != null &&
                    controller.currentLanguage != ''
                ? Locale(controller.currentLanguage, '')
                : null,
            localeResolutionCallback:
                LocalizationService.localeResolutionCallBack,
            supportedLocales: LocalizationService.supportedLocales,
            localizationsDelegates: LocalizationService.localizationsDelegate,
          );
        });
  }
}
