import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';

class adminAddBikePage extends StatefulWidget {
  @override
  _adminAddBikePageState createState() => _adminAddBikePageState();
}

class _adminAddBikePageState extends State<adminAddBikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        title: Text("Add a Bike"),
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
                    padding: const EdgeInsets.only(top: 50, left: 20),
                    child: Text(
                      "burada bisiklet kiralama",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 39, 37, 37)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 90, left: 20),
                    child: Text(
                      "geçmişi bulunur!",
                      style: TextStyle(
                          fontSize: 30, color: Color.fromARGB(255, 22, 14, 14)),
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
