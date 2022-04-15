import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/admin_add_bike_page.dart';
import 'package:kelebike/screens/admin_requests.dart';
import 'package:kelebike/screens/admin_returns.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';

class ReturnPage extends StatefulWidget {
  @override
  _ReturnPageState createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Return(),
    );
  }
}
