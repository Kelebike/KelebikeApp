import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/model/bike.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/utilities/constants.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  BikeService _bikeService = BikeService();

  bool available(String nm) {
    if (nm != "0") {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildAvailable() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: _bikeService.getBike(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {}

          return Container(
            color: Colors.blueAccent,
            height: size.height * 0.5,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: kBoxDecorationStyle,
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Align(
                            child: Icon(Icons.pedal_bike, color: Colors.white)),
                        Align(
                          child: Text(
                            'Bike Availability: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          child: FutureBuilder<int>(
                            future: _bikeService.findWithStatus("nontaken"),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return Icon(
                                  Icons.circle,
                                  color: available('${snapshot.data}')
                                      ? Color.fromARGB(255, 102, 255, 0)
                                      : Color.fromARGB(255, 255, 17, 0),
                                );
                              } else {
                                return Text('Calculating answer...');
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    var size = MediaQuery.of(context).size;
    var taken_counter = 0;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _bikeService.getBike(),
      builder: (context, snaphot) {
        return !snaphot.hasData
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                    height: size.height * 0.4,
                    color: Colors.orange,
                    child: ListView.builder(
                        itemCount: snaphot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot mypost = snaphot.data!.docs[index];
                          if ("${mypost['owner']}" == _user!.email.toString() &&
                              "${mypost['status']}" == "taken") {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                child: Container(
                                  height: size.height * .3,
                                  decoration: kBoxDecorationStyle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "MyBike: ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: 'OpenSans',
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(""),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Code: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "${mypost['code']} ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                " Brand: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "${mypost['brand']}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "   Serial Number: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "${mypost['serialNumber']}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "   Account: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "${mypost['owner']}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "   Issued Date: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "${mypost['issued']}"
                                                    .substring(0, 11),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "   Expired Date: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                "${mypost['return']}"
                                                    .substring(0, 10),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        }),
                  ),
                  _buildAvailable(),
                ],
              );
      },
    );
  }
}
