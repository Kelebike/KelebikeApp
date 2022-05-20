import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? _user = FirebaseAuth.instance.currentUser;
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6CA8F1).withOpacity(0.7),
        elevation: 0,
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                  child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 90, left: 20),
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                          fontSize: 30, color: Color.fromARGB(255, 22, 14, 14)),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _authService.signOut();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                        _user = null;
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Sign out",
                            style: TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.center),
                      )),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
