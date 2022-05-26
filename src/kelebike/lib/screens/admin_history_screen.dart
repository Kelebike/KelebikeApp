import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kelebike/service/history_service.dart';

List<List<String>> itemList = [];

class AdminHistoryScreen extends StatefulWidget {
  @override
  _AdminHistoryScreenState createState() => _AdminHistoryScreenState();
}

class _AdminHistoryScreenState extends State<AdminHistoryScreen> {
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
    parts[0] = parts[0]
        .toString()
        .substring(7, parts[0].toString().length); //account 0
    parts[1] =
        parts[1].toString().substring(6, parts[1].toString().length); //code 1
    parts[3] =
        parts[3].toString().substring(8, parts[3].toString().length); //issued 3
    parts[5] =
        parts[5].toString().substring(8, parts[5].toString().length); //return 5
    print(parts);

    return parts;
  }

  @override
  void initState() {
    super.initState();
    itemList = [
      <String>["ID", "Bike Code", "Account", "Issued", "Return"]
    ];
  }

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () {
          generateCSV();
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                    itemList.add(<String>[
                      mypost.id,
                      infoBike[1],
                      infoBike[0],
                      infoBike[3],
                      infoBike[5]
                    ]);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: size.height * .2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Color(0xFF6CA8F1), width: 2),
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
      ),
    );
  }
}

generateCSV() async {
  print(itemList);
  String csvData = ListToCsvConverter().convert(itemList);
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy-HH-mm-ss').format(now);
  print(csvData);
  if (kIsWeb) {
    final bytes = utf8.encode(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'item_export_${formattedDate}.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  }
}
