import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  User? _user = FirebaseAuth.instance.currentUser;
  bool loggedIn = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (_user == null)
      loggedIn = false;
    else
      loggedIn = true;
    return MaterialApp(
      title: 'Kelebike',
      debugShowCheckedModeBanner: false,
      home: loggedIn ? HomeScreen() : WelcomeScreen(),
    );
  }
}
