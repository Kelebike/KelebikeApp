import 'package:cloud_firestore/cloud_firestore.dart';

class BlackList {
  String id;
  String user;
  String reason;

  BlackList({required this.id, required this.user, required this.reason});

  factory BlackList.fromSnapshot(DocumentSnapshot snapshot) {
    return BlackList(
      id: snapshot.id,
      user: snapshot["user"],
      reason: snapshot["reason"],
    );
  }
}
