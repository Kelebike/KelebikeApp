import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/admin_add_bike_page.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';

class AdminBikesScreen extends StatefulWidget {
  @override
  _AdminBikesScreenState createState() => _AdminBikesScreenState();
}

class _AdminBikesScreenState extends State<AdminBikesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6CA8F1),
        elevation: 0,
        title: Text("Tüm Bisikletler"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 243, 92, 4),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => adminAddBikePage()));
        },
        child: Icon(Icons.add),
      ),
      body: BikePage(),
    );
  }
}
