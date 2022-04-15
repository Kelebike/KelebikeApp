import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:kelebike/utilities/constants.dart';

class TakeBikePage extends StatefulWidget {
  @override
  _TakeBikePageState createState() => _TakeBikePageState();
}

TextEditingController _bikeCodeController = TextEditingController();
Widget _buildBikeCode() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(height: 10.0),
      Container(
        alignment: Alignment.centerLeft,
        decoration: bikeCodeDecorationStyle,
        height: 60.0,
        width: 130.0,
        child: TextField(
          controller: _bikeCodeController,
          keyboardType: TextInputType.phone,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            hintText: 'bike code',
            hintStyle: kHintTextStyle,
          ),
        ),
      ),
    ],
  );
}

class _TakeBikePageState extends State<TakeBikePage> {
  BikeService _bikeService = BikeService();
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6CA8F1),
        elevation: 0,
        title: Text("Take a bike"),
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
                    child: _buildBikeCode(),
                  ),
                ],
              )),
              ElevatedButton(
                onPressed: () async {
                  bool a = await _bikeService.takeBike(
                      _bikeCodeController.text, _user!.email.toString());

                  if (await _bikeService
                          .findWithBikeCode(_bikeCodeController.text) ==
                      null) {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Bike not found!'),
                            ));
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text("Send request"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
