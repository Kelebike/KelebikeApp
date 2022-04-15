import 'package:kelebike/service/bike_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  BikeService _bikeService = BikeService();

  DateTime selectedDate = DateTime.now();
  DateTime nowDate = DateTime.now();

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

                  Future<void> _selectDate(BuildContext context) async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101));
                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                    _bikeService.confirmTakingBike(
                        mypost.id, nowDate.toString(), selectedDate.toString());
                  }

                  if ("${mypost['status']}" == "waiting")
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          height: size.height * .3,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.blue, width: 2),
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
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  else {
                    return Text("");
                  }
                });
      },
    );
  }
}
