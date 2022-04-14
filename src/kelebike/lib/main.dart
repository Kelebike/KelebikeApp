import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kelebike/screens/admin_screen.dart';
import 'package:kelebike/screens/home_screen.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:kelebike/service/bike_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    _bikeService.addBike(
        code: '0824',
        serialNumber: '00002',
        brand: 'GTU',
        status: 'nontaken',
        dateIssued: 'nontaken',
        dateReturn: 'nontaken',
        owner: 'nontaken');

    if (_user == null || !_user!.emailVerified) {
      startPage = LoginScreen();
    } else if (_user!.email == "berkaybaygut@gmail.com") {
      startPage = AdminScreen();
    } else {
      startPage = HomeScreen();
    }
    return MaterialApp(
      title: 'Kelebike',
      debugShowCheckedModeBanner: false,
      home: startPage,
    );
  }
}
