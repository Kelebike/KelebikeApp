import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/service/blacklist_service.dart';
import 'package:kelebike/service/history_service.dart';
import 'package:kelebike/utilities/constants.dart';

class ReturnRequest extends StatefulWidget {
  @override
  _ReturnRequestState createState() => _ReturnRequestState();
}

class _ReturnRequestState extends State<ReturnRequest> {
  HistoryService _historyService = HistoryService();
  var _blackListService = BlackListService();
  BikeService _bikeService = BikeService();
  var _reasonController = TextEditingController();
  User? _user = FirebaseAuth.instance.currentUser;

  Future<void> _buildBlackList(BuildContext context, String user) async {
    print(user);
    Widget _buildReason() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Reason:',
            style: kLabelStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(12),
            height: 5 * 24.0,
            child: TextField(
              controller: _reasonController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter the reason...",
                fillColor: Colors.grey[300],
                filled: true,
              ),
            ),
          ),
        ],
      );
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            content: SizedBox(
                height: 305,
                child: Column(
                  children: [
                    _buildReason(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 5,
                        onPressed: () async {
                          _blackListService.addBlackList(
                              user: user, reason: _reasonController.text);
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.white,
                        child: Text(
                          'Add to the Blacklist',
                          style: TextStyle(
                            color: Color(0xFF527DAA),
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
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
                  Future<void> _showChoiseDialog(BuildContext context) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text(
                                "Bisikleti teslim almak istediğinize emin misiniz?",
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
                                        onTap: () async {
                                          print('${mypost['code']}');
                                          await _historyService
                                              .addHistory('${mypost['code']}');
                                          await _bikeService.confirmReturnBike(
                                              '${mypost['code']}');

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
                                      GestureDetector(
                                        onTap: () async {
                                          _buildBlackList(
                                              context, '${mypost['owner']}');
                                        },
                                        child: Text(
                                          "Kara Listeye Al",
                                          style: TextStyle(
                                              color: Color(0xFF6CA8F1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )));
                        });
                  }

                  if ("${mypost['status']}" == "returned") {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          _showChoiseDialog(context);
                        },
                        child: Container(
                          height: size.height * .3,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Color(0xFF6CA8F1), width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Code: "),
                                      Text(
                                        "${mypost['code']} ",
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(" Brand: "),
                                      Text("${mypost['brand']}"),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("   Serial Number: "),
                                      Text("${mypost['lock']}"),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("   Account: "),
                                      Text("${mypost['owner']}"),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("   Issued: "),
                                      Text("${mypost['issued']}"
                                          .substring(0, 11)),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("   Return: "),
                                      Text("${mypost['return']}"
                                          .substring(0, 11)),
                                    ]),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text("");
                  }
                });
      },
    );
  }
}
