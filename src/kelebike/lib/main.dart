import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
    _bikeService.addBike(
        code: '0824',
        serialNumber: '00002',
        brand: 'GTU',
        status: 'nontaken',
        dateIssued: 'nontaken',
        dateReturn: 'nontaken',
        owner: 'ahmet');
    _bikeService.addBike(
        code: '0829',
        serialNumber: '00002',
        brand: 'GTU',
        status: 'nontaken',
        dateIssued: 'nontaken',
        dateReturn: 'nontaken',
        owner: 'emirhan');

    _bikeService.addBike(
        code: '0839',
        serialNumber: '00002',
        brand: 'GTU',
        status: 'nontaken',
        dateIssued: 'nontaken',
        dateReturn: 'nontaken',
        owner: 'berkay');
    if (_user == null || !_user!.emailVerified) {
      loggedIn = false;
    } else {
      loggedIn = true;
    }
    return MaterialApp(
      title: 'Kelebike',
      debugShowCheckedModeBanner: false,
      home: loggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
