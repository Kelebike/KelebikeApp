import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/service/blacklist_service.dart';

class BlackListPage extends StatefulWidget {
  @override
  _BlackListPageState createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage> {
  BlackListService _blackListService = BlackListService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
      stream: _blackListService.getBlackList(),
      builder: (context, snaphot) {
        return !snaphot.hasData
            ? CircularProgressIndicator()
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFF6CA8F1),
                  elevation: 0,
                  title: Text("Karaliste"),
                  centerTitle: false,
                ),
                body: ListView.builder(
                    itemCount: snaphot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot mypost = snaphot.data!.docs[index];

                      Future<void> _showChoiseDialog(BuildContext context) {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(
                                    "Karalisteden çıkartmak istiyor musunuz?",
                                    textAlign: TextAlign.center,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  content: Container(
                                      height: 50,
                                      width: size.width * 0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () async {
                                                  await _blackListService
                                                      .removeBlackList(
                                                          mypost.id);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Evet",
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Hayır",
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                  ),
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
                            height: size.height * .20,
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
                                  Text("Kullanıcı: "),
                                  Text(
                                    "${mypost['user']} ",
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text("   Açıklama: "),
                                  Text("${mypost['reason']}"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
      },
    );
  }
}
