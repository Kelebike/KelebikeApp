import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/service/history_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryService _historyService = HistoryService();
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

  List parse(String bike) {
    String s = bike;
    var parts = s.split(',');
    return parts;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: _historyService.getHistory(),
      builder: (context, snaphot) {
        return !snaphot.hasData
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: snaphot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot mypost = snaphot.data!.docs[index];
                  String _bike = "${mypost['bike']}";
                  var infoBike = parse(_bike);
                  print(infoBike[1]);
                  Future<void> _showChoiseDialog(BuildContext context) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text(
                                "Silmek istediğinize emin misiniz?",
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
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

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _showChoiseDialog(context);
                      },
                      child: Container(
                        height: size.height * .2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Color(0xFF6CA8F1), width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Bike: "),
                              Text(infoBike[0]),
                              Text(infoBike[1]),
                              Text(infoBike[2]),
                              Text(infoBike[3]),
                              Text(infoBike[4]),
                              Text(infoBike[5]),
                              Text(infoBike[6]),
                              SizedBox(
                                height: 10,
                              ),
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
