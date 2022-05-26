import 'package:flutter/cupertino.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BikePage extends StatefulWidget {
  @override
  _BikePageState createState() => _BikePageState();
}

class _BikePageState extends State<BikePage> {
  BikeService _bikeService = BikeService();
  Color isTaken(String taken) {
    if (taken == "taken") {
      return Color.fromARGB(255, 0, 255, 47);
    } else if (taken == "waiting") {
      return Colors.yellow;
    } else if (taken == "nontaken") {
      return Color.fromARGB(255, 84, 88, 84);
    } else if (taken == "repair") {
      return Color.fromARGB(255, 28, 7, 224);
    } else if (taken == "expired") {
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: _bikeService.getBike(),
      builder: (context, snaphot) {
        return !snaphot.hasData
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: snaphot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot mypost = snaphot.data!.docs[index];
                  if ('${mypost['return']}' != "nontaken") {
                    if (DateTime.parse('${mypost['return']}')
                        .isBefore(DateTime.now())) {
                      _bikeService.updateStatus('${mypost['code']}', "expired");
                    }
                    print('${mypost['return']}');
                  }

                  Future<void> _showChoiseDialog(BuildContext context) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text(
                                "Lütfen Bir İşlem Seçiniz",
                                textAlign: TextAlign.center,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              content: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      new Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.delete,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await _bikeService
                                                  .removeBike(mypost.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Bisikleti Sil",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          )
                                        ],
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.replay_circle_filled,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await _bikeService.repairBike(
                                                  '${mypost['code']}',
                                                  mypost.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Bisikleti Bakıma Al",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          )
                                        ],
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.pedal_bike,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await _bikeService.unrepairBike(
                                                  '${mypost['code']}',
                                                  mypost.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Bisikleti Kullanıma Al",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )));
                        });
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _showChoiseDialog(context);
                      },
                      child: Container(
                        height: size.height * .1,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Color(0xFF6CA8F1), width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Kod: "),
                              Text(
                                "${mypost['code']} ",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              Text("   Sahip: "),
                              Text("${mypost['owner']}"),
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.circle,
                                color: isTaken("${mypost['status']}"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
      },
    );
  }
}
