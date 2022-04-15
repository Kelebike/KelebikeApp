import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/utilities/constants.dart';

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
    var waiting_counter = 0;
    var taken_counter = 0;
    var repair_counter = 0;
    return StreamBuilder(
        stream: _bikeService.getBike(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          if (snapshot.connectionState == ConnectionState.done) {}

          return Container(
            height: double.infinity,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                            child: Icon(Icons.pedal_bike, color: Colors.white)),
                        Align(
                          child: Text(
                            'Total Bicycle: ',
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
                            future: _bikeService.totalBike(),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    color: Colors.white,
                                  ),
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
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: kBoxDecorationStyle,
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(child: Icon(Icons.info, color: Colors.white)),
                        Align(
                          child: Text(
                            'Number Of Request:',
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
                            future: _bikeService.findWithStatus("waiting"),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    color: Colors.white,
                                  ),
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
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: kBoxDecorationStyle,
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                            child: Icon(Icons.autorenew, color: Colors.white)),
                        Align(
                          child: Text(
                            'Bicycles In Circulation:',
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
                            future: _bikeService.findWithStatus("taken"),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    color: Colors.white,
                                  ),
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
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: kBoxDecorationStyle,
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(child: Icon(Icons.build, color: Colors.white)),
                        Align(
                          child: Text(
                            'Bicycles In Renovation:',
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
                            future: _bikeService.findWithStatus("repair"),
                            builder: (BuildContext context,
                                AsyncSnapshot<int> snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return Text('Calculating answer...');
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
