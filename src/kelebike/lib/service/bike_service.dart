import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelebike/model/bike.dart';
import 'package:kelebike/service/storage_service.dart';

class BikeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageService _storageService = StorageService();
  String mediaUrl = '';

  //Bike eklemek için
  Future<Bike?> addBike(
      {required String lock,
      required String brand,
      required String code,
      required String status,
      required String dateIssued,
      required String dateReturn,
      required String owner}) async {
    var ref = _firestore.collection("Bike");
    if (await isDuplicateUniqueName(code)) {
      return null;
    } else {
      var documentRef = await ref.add({
        'lock': lock,
        'brand': brand,
        'code': code,
        'status': status,
        'issued': dateIssued,
        'return': dateIssued,
        'owner': owner
      });

      return Bike(
          id: documentRef.id,
          lock: lock,
          brand: brand,
          code: code,
          status: status,
          dateIssued: dateIssued,
          dateReturn: dateReturn,
          owner: owner);
    }
  }

  //Bike göstermek için
  Stream<QuerySnapshot> getBike() {
    var ref = _firestore.collection("Bike").snapshots();
    return ref;
  }

  //Bike silmek için
  Future<void> removeBike(String docId) {
    var ref = _firestore.collection("Bike").doc(docId).delete();

    return ref;
  }

  Future<bool> isDuplicateUniqueName(String uniqueName) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('code', isEqualTo: uniqueName)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<String?> findWithBikeCode(String code) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('code', isEqualTo: code)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  Future<String?> getLock(String code, String lock) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('code', isEqualTo: code)
        .where('lock', isEqualTo: lock)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  Future<String?> isThisBikeTaken(String code) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('code', isEqualTo: code)
        .where('status', isEqualTo: "nontaken")
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  Future<String?> isThisBikeRepair(String code) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('code', isEqualTo: code)
        .where('status', isEqualTo: "repair")
        .get();

    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  Future<String?> findWithEmail(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('owner', isEqualTo: email)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  Future<int> findWithFutureEmail(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('owner', isEqualTo: email)
        .get();
    if (query.docs.isEmpty) return 0;
    return query.docs.length;
  }

  Future<int> findWithMail(String owner) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('owner', isEqualTo: owner)
        .where('status', isEqualTo: "taken")
        .get();
    return query.docs.length;
  }

  Future<int> findWithReturn(String owner) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('owner', isEqualTo: owner)
        .where('status', isEqualTo: "returned")
        .get();
    return query.docs.length;
  }

  Future<int> findWithUserInfo(String owner) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('owner', isEqualTo: owner)
        .get();
    return query.docs.length;
  }

  Future<int>? totalBike() async {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection("Bike").get();
    if (query.docs.isEmpty) {
      return 0;
    }
    return query.docs.length;
  }

  Future<int>? findWithStatus(String status) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("Bike")
        .where('status', isEqualTo: status)
        .get();
    if (query.docs.isEmpty) {
      return 0;
    }
    return query.docs.length;
  }

  Future<bool> takeBike(String bikeCode, String owner) async {
    String? docId = await findWithBikeCode(bikeCode);
    bool flag = true;
    var ref = _firestore
        .collection("Bike")
        .doc(docId)
        .update({
          'status': "waiting",
          'owner': owner,
        })
        .then((_) => print('Updated'))
        .catchError((error) {
          flag = false;
        });
    return flag;
  }

  Future<bool> updateOwner(String bikeCode, String owner, String issued) async {
    String? docId = await findWithBikeCode(bikeCode);
    bool flag = true;
    var ref = _firestore
        .collection("Bike")
        .doc(docId)
        .update({
          'issued': issued,
          'owner': owner,
        })
        .then((_) => print('Updated'))
        .catchError((error) {
          flag = false;
        });
    return flag;
  }

  Future<bool> updateStatus(String bikeCode, String status) async {
    String? docId = await findWithBikeCode(bikeCode);
    bool flag = true;
    var ref = _firestore
        .collection("Bike")
        .doc(docId)
        .update({
          'status': status,
        })
        .then((_) => print('Updated'))
        .catchError((error) {
          flag = false;
        });
    return flag;
  }

  Future<bool> repairBike(String bikeCode, String docId) async {
    String? rep = await this.isThisBikeTaken(bikeCode);
    bool flag = true;
    if (rep != null) {
      var ref = _firestore
          .collection("Bike")
          .doc(docId)
          .update({
            'status': "repair",
          })
          .then((_) => print('Updated'))
          .catchError((error) {
            flag = false;
          });
    }
    print(rep);

    return flag;
  }

  Future<bool> unrepairBike(String bikeCode, String docId) async {
    String? rep = await this.isThisBikeRepair(bikeCode);
    bool flag = true;
    if (rep != null) {
      var ref = _firestore
          .collection("Bike")
          .doc(docId)
          .update({
            'status': "nontaken",
          })
          .then((_) => print('Updated'))
          .catchError((error) {
            flag = false;
          });
    }
    print(rep);

    return flag;
  }

  Future<bool> confirmTakingBike(
      String docId, String issued, String returned, String lock) async {
    bool flag = true;
    var ref = _firestore
        .collection("Bike")
        .doc(docId)
        .update({
          'status': "taken",
          'issued': issued,
          'return': returned,
          'lock': lock,
        })
        .then((_) => print('Updated'))
        .catchError((error) {
          flag = false;
        });
    return flag;
  }

  Future<bool> returnBike(String bikeCode) async {
    bool flag = true;
    var ref = _firestore
        .collection("Bike")
        .doc(await findWithBikeCode(bikeCode))
        .update({
          'status': "returned",
        })
        .then((_) => print('return request from user!'))
        .catchError((error) {
          flag = false;
        });
    return flag;
  }

  Future<bool> confirmReturnBike(String bikeCode) async {
    bool flag = true;
    var ref = _firestore
        .collection("Bike")
        .doc(await findWithBikeCode(bikeCode))
        .update({
          'status': "nontaken",
          'issued': "nontaken",
          'return': "nontaken",
          'owner': "nontaken",
        })
        .then((_) => print('Returned'))
        .catchError((error) {
          flag = false;
        });
    return flag;
  }
}
