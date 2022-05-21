import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:image_picker/image_picker.dart';
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
            color: Color.fromARGB(255, 255, 255, 255).withOpacity(0),
            height: size.height * 0.3,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            child: Icon(Icons.pedal_bike,
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.7))),
                        Align(
                          child: Text(
                            'Bike Availability: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color:
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
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
                                      ? Color.fromARGB(255, 94, 217, 12)
                                          .withOpacity(0.7)
                                      : Color.fromARGB(255, 158, 60, 53),
                                );
                              } else {
                                return Text('Loading...');
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
    int flag = 0;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _bikeService.getBike(),
        builder: (context, snaphot) {
          return !snaphot.hasData
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    _buildAvailable(),
                    Container(
                      height: size.height * 0.6122,
                      color: Colors.white.withOpacity(0),
                      child: ListView.builder(
                          itemCount: snaphot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot mypost = snaphot.data!.docs[index];
                            if ("${mypost['owner']}" ==
                                    _user!.email.toString() &&
                                "${mypost['status']}" == "taken") {
                              flag++;
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  child: Container(
                                    height: size.height * .35,
                                    decoration: kBoxDecorationStyle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CountdownTimer(
                                            endTime: DateTime.parse(
                                                    "${mypost['return']}")
                                                .millisecondsSinceEpoch,
                                          ),
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
                                                const Text(
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
                                                  style: const TextStyle(
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
                            } else if (flag == 0) {
                              flag++;
                              return Image.asset('assets/logos/opps.png',
                                  fit: BoxFit.fitHeight);
                            } else
                              return SizedBox.shrink();
                          }),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
