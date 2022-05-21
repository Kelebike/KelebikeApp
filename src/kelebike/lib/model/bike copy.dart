import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kelebike/model/bike.dart';

class History {
  String id;
  Bike bike;

  History({
    required this.id,
    required this.bike,
  });

  factory History.fromSnapshot(DocumentSnapshot snapshot) {
    return History(id: snapshot.id, bike: snapshot["bike"]);
  }
}
