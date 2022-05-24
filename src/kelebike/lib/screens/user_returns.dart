import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:kelebike/screens/home_screen.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/screens/qr_overlay.dart';
import 'package:kelebike/screens/qr_scanner_controller.dart';
import 'package:kelebike/screens/take_bike_with_keyboard.dart';
import 'package:kelebike/screens/user_info_page.dart';
import 'package:kelebike/screens/user_returns_with_keyboard.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:kelebike/service/history_service.dart';
import 'package:kelebike/utilities/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ReturnQRPage extends StatefulWidget {
  @override
  _ReturnQRPageState createState() => _ReturnQRPageState();
}

TextEditingController _bikeCodeController = TextEditingController();

class _ReturnQRPageState extends State<ReturnQRPage> {
  HistoryService _historyService = HistoryService();
  BikeService _bikeService = BikeService();
  User? _user = FirebaseAuth.instance.currentUser;

  MobileScannerController cameraController = MobileScannerController();
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6CA8F1),
      appBar: AppBar(
        backgroundColor: Color(0xFF6CA8F1),
        elevation: 0,
        title: Text("Give back the bike"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Return()));
              },
              icon: const Icon(Icons.keyboard)),
          IconButton(
              onPressed: () {
                setState(() {
                  toggle = !toggle;
                });
                cameraController.toggleTorch();
              },
              icon: toggle
                  ? const Icon(Icons.flash_on)
                  : const Icon(Icons.flash_off)),
          IconButton(
              onPressed: () {
                cameraController.switchCamera();
              },
              icon: const Icon(Icons.camera_rear_outlined)),
        ],
        centerTitle: false,
      ),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) async {
              String? _returnBarcode = barcode.rawValue;
              debugPrint('Barcode Found!' + barcode.rawValue!);
              await _historyService.getBikeWithCode(_returnBarcode!);
              String? docID =
                  await _bikeService.findWithBikeCode(_returnBarcode);

              if (await _bikeService.findWithReturn(_user!.email.toString()) ==
                  1) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text('You already have a request.'),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                          ],
                        ));
              } else if (await _bikeService
                      .findWithMail(_user!.email.toString()) !=
                  1) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text('You have no bike.'),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                          ],
                        ));
              } else if (docID == null) {
                print(docID);
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Bike not found!'),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                          ],
                        ));
              } else {
                await _bikeService.returnBike(_returnBarcode);

                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Request Succesfull'),
                          content: Text('Your return request has been sent...'),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("OK"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                          ],
                        ));
              }
            },
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.7)),
        ],
      ),
    );
  }
}
