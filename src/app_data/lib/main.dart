import 'package:app_data/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_data/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelebike',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
