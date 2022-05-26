import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/utilities/constants.dart';
import 'package:kelebike/widgets/my_horizontal_list.dart';
import 'package:string_validator/string_validator.dart';

class AdminInfoPage extends StatefulWidget {
  @override
  _AdminInfoPageState createState() => _AdminInfoPageState();
}

class _AdminInfoPageState extends State<AdminInfoPage> {
  BikeService _bikeService = BikeService();
  Color isTaken(String taken) {
    if (taken == "taken") {
      return Colors.red;
    } else if (taken == "waiting") {
      return Colors.yellow;
    } else if (taken == "nontaken") {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String bike_counter;
    var waiting_counter = 2.0;
    var taken_counter = 0;
    var repair_counter = 0;

    return StreamBuilder(
        stream: _bikeService.getBike(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {}
          return Column(
            children: [
              //_buildAvailable(),
              //_test(),
              //IconButton( onPressed: () { print("pressed");},
              //icon: Icon(Icons.calendar_month),
              //color: Colors.black),
              Expanded(
                child: Container(
                  height: size.height * 0.55,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          DocumentSnapshot mypost = snapshot.data!.docs[index];

                          return SizedBox(
                            height: size.height * .55,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    FutureBuilder<int>(
                                      future: _bikeService.totalBike(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return MyHorizontalList(
                                            height: 349,
                                            width: 246,
                                            startColor: Colors.orange.shade100,
                                            endColor: Color.fromARGB(
                                                255, 241, 199, 33),
                                            courseHeadline: 'Toplam',
                                            courseTitle:
                                                'TOPLAM \nBISIKLET\nSAYISI : ' +
                                                    '${snapshot.data}',
                                            courseImage:
                                                'assets/logos/total.png',
                                            scale: 14,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    FutureBuilder<int>(
                                      future: _bikeService
                                          .findWithStatus("nontaken"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return MyHorizontalList(
                                            height: 349,
                                            width: 246,
                                            startColor: Colors.orange.shade100,
                                            endColor: Color.fromARGB(
                                                255, 54, 235, 244),
                                            courseHeadline: 'Uygun Bisiklet',
                                            courseTitle:
                                                'TOPLAM \nBISIKLET\nSAYISI : ' +
                                                    '${snapshot.data}',
                                            courseImage:
                                                'assets/logos/available.png',
                                            scale: 1.8,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    FutureBuilder<int>(
                                      future:
                                          _bikeService.findWithStatus("repair"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return MyHorizontalList(
                                            height: 349,
                                            width: 246,
                                            startColor: Color.fromARGB(
                                                255, 215, 212, 207),
                                            endColor:
                                                Color.fromARGB(255, 70, 81, 87),
                                            courseHeadline: 'Tamir',
                                            courseTitle:
                                                'TOPLAM TAMİRDEKİ \nBİSİKLET\nSAYISI : ' +
                                                    '${snapshot.data}',
                                            courseImage:
                                                'assets/logos/repair.png',
                                            scale: 8,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    FutureBuilder<int>(
                                      future:
                                          _bikeService.findWithStatus("taken"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return MyHorizontalList(
                                            height: 349,
                                            width: 246,
                                            startColor: Color.fromARGB(
                                                255, 225, 246, 133),
                                            endColor: Color.fromARGB(
                                                255, 0, 183, 110),
                                            courseHeadline: 'Dolaşım',
                                            courseTitle:
                                                'TOPLAM DOLAŞIMDAKİ \nBİSİKLET\nSAYISI : ' +
                                                    '${snapshot.data}',
                                            courseImage:
                                                'assets/logos/circulation.png',
                                            scale: 16,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    FutureBuilder<int>(
                                      future: _bikeService
                                          .findWithStatus("waiting"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return MyHorizontalList(
                                            height: 349,
                                            width: 246,
                                            startColor: Color.fromARGB(
                                                255, 191, 208, 172),
                                            endColor: Color.fromARGB(
                                                255, 125, 158, 214),
                                            courseHeadline: 'Alım İsteği',
                                            courseTitle:
                                                'TOPLAM \nALIM İSTEĞİ\nSAYISI : ' +
                                                    '${snapshot.data}',
                                            courseImage:
                                                'assets/logos/take.png',
                                            scale: 9,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    FutureBuilder<int>(
                                      future: _bikeService
                                          .findWithStatus("returned"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        if (snapshot.hasData) {
                                          return MyHorizontalList(
                                            height: 349,
                                            width: 246,
                                            startColor: Color.fromARGB(
                                                255, 240, 216, 232),
                                            endColor: Color.fromARGB(
                                                255, 196, 12, 147),
                                            courseHeadline: 'İade İsteği',
                                            courseTitle:
                                                'TOPLAM \nİADE İSTEĞİ\nSAYISI : ' +
                                                    '${snapshot.data}',
                                            courseImage:
                                                'assets/logos/return.png',
                                            scale: 8,
                                          );
                                        } else {
                                          return CircularProgressIndicator();
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
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset(
                  'assets/logos/admin.png',
                  height: size.height * .3,
                  width: size.width,
                ),
              )
            ],
          );
        });
  }
}
