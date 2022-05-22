import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/service/history_service.dart';
import 'package:kelebike/utilities/constants.dart';

class ReturnRequest extends StatefulWidget {
  @override
  _ReturnRequestState createState() => _ReturnRequestState();
}

class _ReturnRequestState extends State<ReturnRequest> {
  HistoryService _historyService = HistoryService();
  BikeService _bikeService = BikeService();
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
                                        onTap: () {
                                          Navigator.pop(context);
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

                  if ("${mypost['status']}" == "waiting_r") {
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
                                      Text("${mypost['serialNumber']}"),
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
