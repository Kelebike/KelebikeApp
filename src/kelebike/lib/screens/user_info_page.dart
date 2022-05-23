import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelebike/model/bike.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/utilities/constants.dart';
import 'package:kelebike/widgets/my_horizontal_list.dart';
import 'package:string_validator/string_validator.dart';

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
          return Center(
            child: Container(
              color: Color.fromARGB(255, 255, 255, 255).withOpacity(0),
              height: size.height * 0.3,
              width: size.width * 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    decoration: kBoxDecorationStyle,
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            child: Icon(Icons.pedal_bike,
                                color: Color.fromARGB(255, 255, 255, 255)
                                    .withOpacity(0.7))),
                        Align(),
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
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.access_alarm_outlined))
                ],
              ),
            ),
          );
        });
  }

  Widget _test() {
    User? _user = FirebaseAuth.instance.currentUser;
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Bike').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                if (_user!.email.toString() == doc['owner'] &&
                    doc['status'] == 'taken') {
                  return Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          doc['code'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                            color: Colors.orange.shade100,
                          ),
                        ),
                        Text(doc['return']),
                        Text(doc['issued']),
                        CountdownTimer(
                          endTime: DateTime.parse(doc['return'])
                              .millisecondsSinceEpoch,
                        ),
                        _buildAvailable(),
                        Container(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset('assets/logos/cool_bike.jpg',
                                fit: BoxFit.fitHeight),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              });
        } else {
          return Text("No data");
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    var size = MediaQuery.of(context).size;
    var taken_counter = 0;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    double opacity = 1; // bu 0 olursa arkadaki gözükür.

    return StreamBuilder(
        stream: _bikeService.getBike(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {}
          return FutureBuilder<int>(
            future: _bikeService.findWithUserInfo(_user!.email.toString()),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                if (available('${snapshot.data}')) {
                  return Scaffold(
                      body: Column(
                    children: [
                      Stack(
                        children: [
                          MyHorizontalList(
                            width: 246,
                            startColor: Colors.orange.shade100,
                            endColor: Colors.red,
                            courseHeadline: 'Bike availability',
                            courseTitle: 'NUMBER OF \nAVAILABLE\nBIKE',
                            courseImage: 'assets/logos/available.png',
                            scale: 1.8,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: _bikeService.getBike(),
                            builder: (context, snaphot) {
                              int flag = 0;
                              return !snaphot.hasData
                                  ? CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        Container(
                                          height: size.height * 0.6,
                                          color:
                                              Colors.white.withOpacity(opacity),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: ListView.builder(
                                                itemCount:
                                                    snaphot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  DocumentSnapshot mypost =
                                                      snaphot.data!.docs[index];
                                                  if ("${mypost['owner']}" ==
                                                          _user.email
                                                              .toString() &&
                                                      "${mypost['status']}" ==
                                                          "taken") {
                                                    return SizedBox(
                                                      height: size.height * .55,
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        itemCount: 1,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Row(
                                                            children: [
                                                              MyHorizontalList(
                                                                width: 246,
                                                                startColor: Colors
                                                                    .orange
                                                                    .shade100,
                                                                endColor:
                                                                    Colors.red,
                                                                courseHeadline:
                                                                    'My Bike',
                                                                courseTitle:
                                                                    'Bike code: \n' +
                                                                        '${mypost['code']}\n\n' +
                                                                        'Lock : \nTODO!!',
                                                                courseImage:
                                                                    'assets/logos/bike_woman.png',
                                                                scale: 1.4,
                                                              ),
                                                              Stack(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                children: [
                                                                  MyHorizontalList(
                                                                    width: 246,
                                                                    startColor: Colors
                                                                        .orange
                                                                        .shade100,
                                                                    endColor:
                                                                        Colors
                                                                            .red,
                                                                    courseHeadline:
                                                                        'Remaining Time',
                                                                    courseTitle: 'Issued: \n' +
                                                                        '${mypost['issued']}'.substring(
                                                                            0,
                                                                            11) +
                                                                        '\nReturn :\n' +
                                                                        '${mypost['return']}'.substring(
                                                                            0,
                                                                            11),
                                                                    courseImage:
                                                                        'assets/logos/countdown.png',
                                                                    scale: 1.8,
                                                                  ),
                                                                  CountdownTimer(
                                                                    endTime: DateTime.parse(
                                                                            "${mypost['return']}")
                                                                        .millisecondsSinceEpoch,
                                                                    widgetBuilder: (_,
                                                                        CurrentRemainingTime?
                                                                            time) {
                                                                      if (time ==
                                                                          null) {
                                                                        return const Text(
                                                                            ''); //time expired
                                                                      }
                                                                      return Text(
                                                                        '\n\n\n    ' +
                                                                            '${time.days}'.padLeft(2,
                                                                                '0') +
                                                                            ' : ' +
                                                                            '${time.hours}'.padLeft(2,
                                                                                '0') +
                                                                            ' : ' +
                                                                            '${time.min}'.padLeft(2,
                                                                                '0') +
                                                                            ' : ' +
                                                                            '${time.sec}'.padLeft(2,
                                                                                '0'),
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              25,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              FutureBuilder<
                                                                  int>(
                                                                future: _bikeService
                                                                    .findWithStatus(
                                                                        "nontaken"),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            int>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    return MyHorizontalList(
                                                                      width:
                                                                          246,
                                                                      startColor: Colors
                                                                          .orange
                                                                          .shade100,
                                                                      endColor:
                                                                          Colors
                                                                              .red,
                                                                      courseHeadline:
                                                                          'Bike availability',
                                                                      courseTitle:
                                                                          'NUMBER OF \nAVAILABLE\nBIKE : ' +
                                                                              '${snapshot.data}',
                                                                      courseImage:
                                                                          'assets/logos/available.png',
                                                                      scale:
                                                                          1.8,
                                                                    );
                                                                  } else {
                                                                    return Text(
                                                                        'Calculating answer...');
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  } else {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                }),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ],
                      ),

                      //Image.asset('assets/logos/cool_bike.jpg', fit: BoxFit.fitHeight),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.asset(
                          'assets/logos/cool_bike.jpg',
                          height: size.height * .3,
                          width: size.width,
                        ),
                      )
                    ],
                  ));
                } else {
                  // user has no bike
                  return Scaffold(
                      body: Column(
                    children: [
                      Stack(
                        children: [
                          MyHorizontalList(
                            width: 246,
                            startColor: Colors.orange.shade100,
                            endColor: Colors.red,
                            courseHeadline: 'Bike availability',
                            courseTitle: 'NUMBER OF \nAVAILABLE\nBIKE',
                            courseImage: 'assets/logos/available.png',
                            scale: 1.8,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: _bikeService.getBike(),
                            builder: (context, snaphot) {
                              int flag = 0;
                              return !snaphot.hasData
                                  ? CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        Container(
                                          height: size.height * 0.6,
                                          color:
                                              Colors.white.withOpacity(opacity),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: ListView.builder(
                                                itemCount: 1,
                                                itemBuilder: (context, index) {
                                                  DocumentSnapshot mypost =
                                                      snaphot.data!.docs[index];

                                                  return SizedBox(
                                                    height: size.height * .55,
                                                    child: ListView.builder(
                                                      itemCount: 1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: FutureBuilder<
                                                              int>(
                                                            future: _bikeService
                                                                .findWithStatus(
                                                                    "nontaken"),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        int>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return MyHorizontalList(
                                                                  width:
                                                                      size.width *
                                                                          0.75,
                                                                  startColor: Colors
                                                                      .orange
                                                                      .shade100,
                                                                  endColor:
                                                                      Colors
                                                                          .red,
                                                                  courseHeadline:
                                                                      'Bike availability',
                                                                  courseTitle:
                                                                      'NUMBER OF \nAVAILABLE\nBIKE : ' +
                                                                          '${snapshot.data}',
                                                                  courseImage:
                                                                      'assets/logos/available.png',
                                                                  scale: 1.8,
                                                                );
                                                              } else {
                                                                return Text(
                                                                    'Calculating answer...');
                                                              }
                                                            },
                                                          ),
                                                        );
                                                        return Row(
                                                          children: [
                                                            FutureBuilder<int>(
                                                              future: _bikeService
                                                                  .findWithStatus(
                                                                      "nontaken"),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          int>
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return MyHorizontalList(
                                                                    width: 300,
                                                                    startColor: Colors
                                                                        .orange
                                                                        .shade100,
                                                                    endColor:
                                                                        Colors
                                                                            .red,
                                                                    courseHeadline:
                                                                        'Bike availability',
                                                                    courseTitle:
                                                                        'NUMBER OF \nAVAILABLE\nBIKE : ' +
                                                                            '${snapshot.data}',
                                                                    courseImage:
                                                                        'assets/logos/available.png',
                                                                    scale: 1.8,
                                                                  );
                                                                } else {
                                                                  return Text(
                                                                      'Calculating answer...');
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ],
                      ),

                      //Image.asset('assets/logos/cool_bike.jpg', fit: BoxFit.fitHeight),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.asset(
                          'assets/logos/cool_bike.jpg',
                          height: size.height * .3,
                          width: size.width,
                        ),
                      )
                    ],
                  ));
                }
              } else {
                return Text('Loading...');
              }
            },
          );
        });
  }
}
