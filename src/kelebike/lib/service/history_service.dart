import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelebike/model/bike.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:kelebike/service/storage_service.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageService _storageService = StorageService();

  //History eklemek için
  Future<DocumentReference<Map<String, dynamic>>> addHistory(
      String docId) async {
    BikeService _bikeService = BikeService();
    String? id = await _bikeService.findWithBikeCode(docId);
    bool flag = true;
    var refBike = _firestore
        .collection("Bike")
        .doc(id)
        .update({
          'return': DateTime.now().toString(),
        })
        .then((_) => print('Updated'))
        .catchError((error) {
          flag = false;
        });

    var ref = _firestore.collection("History");
    var bike = await _firestore.collection("Bike").doc(docId);
    var _info = await getBikeWithCode(docId);
    print(_info);
    Map<String, dynamic> _bike = {'id': bike.toString(), 'bike': _info};

    var documentRef = await ref.add(_bike);
    return bike;
  }

  Future<Object?> getBikeWithCode(String code) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('code', isEqualTo: code)
        .get();
    if (query.docs.isNotEmpty) {
      print(query.docs[0].data());
      return query.docs[0].data();
    }
    print(code);
    return null;
  }

  //History göstermek için
  Stream<QuerySnapshot> getHistory() {
    var ref = _firestore.collection("History").snapshots();
    return ref;
  }
}
