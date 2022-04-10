import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kelebike/screens/authenticate.dart';
import 'package:kelebike/screens/home_screen.dart';
import 'package:kelebike/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelebike',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
