import 'package:cloud_firestore/cloud_firestore.dart';

class Bike {
  String id;
  String serialNumber;
  String brand;
  String code;
  String status;
  String dateIssued;
  String dateReturn;
  String owner;

  Bike({
    required this.id,
    required this.serialNumber,
    required this.brand,
    required this.code,
    required this.status,
    required this.dateIssued,
    required this.dateReturn,
    required this.owner,
  });

  factory Bike.fromSnapshot(DocumentSnapshot snapshot) {
    return Bike(
        id: snapshot.id,
        serialNumber: snapshot["serial_number"],
        brand: snapshot["brand"],
        code: snapshot["code"],
        status: snapshot["status"],
        dateIssued: snapshot["issued"],
        dateReturn: snapshot["return"],
        owner: snapshot["owner"]);
  }
}
