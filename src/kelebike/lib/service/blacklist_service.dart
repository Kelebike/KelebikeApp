import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelebike/model/blacklist.dart';
import 'package:kelebike/service/storage_service.dart';

class BlackListService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageService _storageService = StorageService();
  String mediaUrl = '';

  //BlackList eklemek için
  Future<BlackList?> addBlackList({
    required String user,
    required String reason,
  }) async {
    var ref = _firestore.collection("BlackList");
    if (await isDuplicateUniqueName(user)) {
      return null;
    } else {
      var documentRef = await ref.add({
        'user': user,
        'reason': reason,
      });

      return BlackList(id: documentRef.id, user: user, reason: reason);
    }
  }

  //BlackList göstermek için
  Stream<QuerySnapshot> getBlackList() {
    var ref = _firestore.collection("BlackList").snapshots();
    return ref;
  }

  //BlackList silmek için
  Future<void> removeBlackList(String docId) {
    var ref = _firestore.collection("BlackList").doc(docId).delete();

    return ref;
  }

  Future<bool> isDuplicateUniqueName(String uniqueName) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("BlackList")
        .where('user', isEqualTo: uniqueName)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<String?> findWithEmail(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("BlackList")
        .where('user', isEqualTo: email)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }
}
