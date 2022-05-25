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

  Widget takeBikeUserInfo() {
    return Text(
        "\n\n\nUser'ın bisikleti yok! \nTake a bike button ve bisikletin yok buraya gelecek!!");
  }

  Widget _buildReturnBtn(String bikeCode) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.65,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF6CA8F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5.0,
          ),
          onPressed: () {
            Future<void> _showChoiseDialog(BuildContext context) {
              return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text(
                          "Bisikleti teslim etmek istediğinize emin misiniz?",
                          textAlign: TextAlign.center,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        content: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    await _bikeService.returnBike(bikeCode);

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Evet",
                                    style: TextStyle(
                                        color: Color(0xFF6CA8F1),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Vazgeç",
                                    style: TextStyle(
                                        color: Color(0xFF6CA8F1),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )));
                  });
            }

            ;
            _showChoiseDialog(context);
          },
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            children: [
              Icon(Icons.arrow_back),
              Text(
                " Give back the bike!",
              ),
            ],
          )),
    );
  }

  Widget bikeAvailable() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: _bikeService.getBike(),
      builder: (context, snaphot) {
        int flag = 0;
        return !snaphot.hasData
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                    color: Colors.green.withOpacity(0.4),
                    height: size.height * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            DocumentSnapshot mypost = snaphot.data!.docs[index];

                            return SizedBox(
                              height: size.height * .25,
                              child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: FutureBuilder<int>(
                                      future: _bikeService
                                          .findWithStatus("nontaken"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return MyHorizontalList(
                                            height: size.height * 0.2,
                                            width: size.width * 0.9,
                                            startColor: Color.fromARGB(
                                                255, 193, 218, 241),
                                            endColor: Color.fromARGB(
                                                255, 24, 106, 228),
                                            courseHeadline: 'Bike availability',
                                            courseTitle:
                                                'NUMBER OF \nAVAILABLE\nBIKE : ' +
                                                    '${snapshot.data}',
                                            courseImage:
                                                'assets/logos/available.png',
                                            scale: 2.2,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    String bikeCode = "";
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
                      backgroundColor: Color(0xFF6CA8F1).withOpacity(0.4),
                      body: Column(
                        children: [
                          bikeAvailable(),
                          Stack(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: _bikeService.getBike(),
                                builder: (context, snaphot) {
                                  int flag = 0;
                                  return !snaphot.hasData
                                      ? CircularProgressIndicator()
                                      : Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.75 - 60,
                                              color:
                                                  Colors.green.withOpacity(0.4),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: ListView.builder(
                                                    itemCount: snaphot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      DocumentSnapshot mypost =
                                                          snaphot.data!
                                                              .docs[index];
                                                      if ("${mypost['owner']}" ==
                                                              _user.email
                                                                  .toString() &&
                                                          "${mypost['status']}" ==
                                                              "taken") {
                                                        bikeCode =
                                                            '${mypost['code']}';
                                                        return SizedBox(
                                                          //todo!
                                                          height: size.height *
                                                              0.60,
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            itemCount: 1,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Column(
                                                                children: [
                                                                  MyHorizontalList(
                                                                    height: 200,
                                                                    width:
                                                                        size.width *
                                                                            0.9,
                                                                    startColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            237,
                                                                            187,
                                                                            112),
                                                                    endColor: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            245,
                                                                            180,
                                                                            30),
                                                                    courseHeadline:
                                                                        'My Bike',
                                                                    courseTitle:
                                                                        'Bike code: \n' +
                                                                            '${mypost['code']}\n' +
                                                                            'Lock : \nTODO!!',
                                                                    courseImage:
                                                                        'assets/logos/bike_woman.png',
                                                                    scale: 1.7,
                                                                  ),
                                                                  Stack(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    children: [
                                                                      MyHorizontalList(
                                                                        height:
                                                                            200,
                                                                        width: size.width *
                                                                            .9,
                                                                        startColor: Color.fromARGB(
                                                                            255,
                                                                            233,
                                                                            187,
                                                                            187),
                                                                        endColor: Color.fromARGB(
                                                                            255,
                                                                            252,
                                                                            95,
                                                                            229),
                                                                        courseHeadline:
                                                                            'Remaining Time',
                                                                        courseTitle: 'Issued: \n' +
                                                                            '${mypost['issued']}'.substring(0,
                                                                                11) +
                                                                            '\nReturn :\n' +
                                                                            '${mypost['return']}'.substring(0,
                                                                                11),
                                                                        courseImage:
                                                                            'assets/logos/countdown.png',
                                                                        scale:
                                                                            2.2,
                                                                      ),
                                                                      CountdownTimer(
                                                                        endTime:
                                                                            DateTime.parse("${mypost['return']}").millisecondsSinceEpoch,
                                                                        widgetBuilder: (_,
                                                                            CurrentRemainingTime?
                                                                                time) {
                                                                          if (time ==
                                                                              null) {
                                                                            return const Text(''); //time expired
                                                                          }
                                                                          return Text(
                                                                            '\n\n\n\n\n\n\n      ' +
                                                                                '${time.days}'.padLeft(2, '0') +
                                                                                ' : ' +
                                                                                '${time.hours}'.padLeft(2, '0') +
                                                                                ' : ' +
                                                                                '${time.min}'.padLeft(2, '0') +
                                                                                ' : ' +
                                                                                '${time.sec}'.padLeft(2, '0'),
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Color.fromARGB(255, 115, 115, 115),
                                                                              fontSize: 20,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  _buildReturnBtn(
                                                                      bikeCode),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      } else if (("${mypost['owner']}" ==
                                                                  _user.email
                                                                      .toString() &&
                                                              "${mypost['status']}" ==
                                                                  "waiting") ||
                                                          ("${mypost['owner']}" ==
                                                                  _user.email
                                                                      .toString() &&
                                                              "${mypost['status']}" ==
                                                                  "returned")) {
                                                        return Text(
                                                            "Waiting for confirmation");
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
                        ],
                      ));
                } else {
                  // user has no bike
                  return Scaffold(
                      body: Column(
                    children: [
                      bikeAvailable(),
                      takeBikeUserInfo(),
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
