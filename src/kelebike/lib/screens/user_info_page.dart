import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelebike/model/bike.dart';
import 'package:kelebike/screens/take_bike_page.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/service/blacklist_service.dart';
import 'package:kelebike/service/localization_service.dart';
import 'package:kelebike/utilities/constants.dart';
import 'package:kelebike/widgets/my_horizontal_list.dart';
import 'package:string_validator/string_validator.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final localizationController = Get.find<LocalizationController>();
  BikeService _bikeService = BikeService();

  bool available(String nm) {
    if (nm != "0") {
      return true;
    } else {
      return false;
    }
  }

  Widget takeBikeUserInfo() {
    var size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        child: Column(children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset("assets/logos/man_bike.jpg"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "There is no bike here. Let's fly like kelebike!\n",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: size.height * 0.15,
          ),
          _buildTakeBtn(),
        ]),
        height: size.height * 0.65,
        width: size.width * 0.9,
      ),
    );
  }

  Widget expiredUser(String bikeCode) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        child: Column(children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset("assets/logos/workshop.jpg"),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Your rental time is up!",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 15,
            ),
          ),
          Text(
            "Please leave the bike at the workshop.\n",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: size.height * 0.15,
          ),
          _buildReturnBtn(bikeCode),
        ]),
        height: size.height * 0.65,
        width: size.width * 0.9,
      ),
    );
  }

  Widget waitingForConfirmation() {
    return Center(
      child: SizedBox(
        child: Column(children: [
          Text(
            "Waiting for confirmation!\n",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
            ),
          ),
          CircularProgressIndicator()
        ]),
        height: 200.0,
        width: 300.0,
      ),
    );
  }

  Widget _buildTakeBtn() {
    User? _user = FirebaseAuth.instance.currentUser;
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
          onPressed: () async {
            var _blackListService = BlackListService();
            String? isInBlack =
                await _blackListService.findWithEmail(_user!.email.toString());
            print(isInBlack);
            if (isInBlack == null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TakeBikePage()));
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Opps!"),
                    content: new Text(
                        "You're in blacklist now. You can't take a bike..."),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            children: [
              Icon(Icons.bike_scooter),
              Text(
                " Let's take a bike!",
              ),
            ],
          )),
    );
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
                LocalizationService.of(context).translate('gv_bck_bike')!,
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
                    color: Colors.green.shade200,
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
                                            courseHeadline:
                                                LocalizationService.of(context)
                                                    .translate('bike_avail')!,
                                            courseTitle: LocalizationService.of(
                                                        context)
                                                    .translate(
                                                        'numb_of_avail_bikes_c')! +
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
                                              color: Colors.green.shade200,
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
                                                                    courseHeadline: LocalizationService.of(
                                                                            context)
                                                                        .translate(
                                                                            'my_bike')!,
                                                                    courseTitle: LocalizationService.of(context).translate(
                                                                            'bike_code_c_n')! +
                                                                        '${mypost['code']}\n' +
                                                                        LocalizationService.of(context)
                                                                            .translate('lock')! +
                                                                        '${mypost['lock']}',
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
                                                                            LocalizationService.of(context).translate('rmn_time_n')!,
                                                                        courseTitle: LocalizationService.of(context).translate('issued')! +
                                                                            '${mypost['issued']}'.substring(0,
                                                                                11) +
                                                                            LocalizationService.of(context).translate(
                                                                                'n_rtrn_n')! +
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
                                                                            return Text(
                                                                              '\n\n\n\n\n\n\n     Time Expired!',
                                                                              style: GoogleFonts.roboto(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromARGB(255, 115, 115, 115),
                                                                                fontSize: 20,
                                                                              ),
                                                                            );
                                                                            ; //time expired
                                                                          }
                                                                          String
                                                                              days =
                                                                              '${time.days}';

                                                                          String
                                                                              hours =
                                                                              '${time.hours}';

                                                                          String
                                                                              mins =
                                                                              '${time.min}';
                                                                          String
                                                                              secs =
                                                                              '${time.sec}';
                                                                          if (time.days ==
                                                                              null) {
                                                                            days =
                                                                                "";
                                                                          }
                                                                          if (time.hours ==
                                                                              null) {
                                                                            hours =
                                                                                "";
                                                                          }
                                                                          if (time.min ==
                                                                              null) {
                                                                            mins =
                                                                                "";
                                                                          }
                                                                          if (time.sec ==
                                                                              null) {
                                                                            secs =
                                                                                "";
                                                                          }

                                                                          return Text(
                                                                            '\n\n\n\n\n\n\n      ' +
                                                                                days.padLeft(2, '0') +
                                                                                ' : ' +
                                                                                hours.padLeft(2, '0') +
                                                                                ' : ' +
                                                                                mins.padLeft(2, '0') +
                                                                                ' : ' +
                                                                                secs.padLeft(2, '0'),
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
                                                        return waitingForConfirmation();
                                                      } else if ("${mypost['owner']}" ==
                                                              _user.email
                                                                  .toString() &&
                                                          "${mypost['status']}" ==
                                                              "expired") {
                                                        return expiredUser(
                                                            "${mypost['code']}");
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
                      backgroundColor: Colors.green.shade200,
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
