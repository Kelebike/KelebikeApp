import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/blacklist_page.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement, Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../service/localization_service.dart';

class AdminSettingsScreen extends StatefulWidget {
  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettingsScreen> {
  User? _user = FirebaseAuth.instance.currentUser;
  AuthService _authService = AuthService();
  bool _toggle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6CA8F1),
        elevation: 0,
        title: Text("Ayarlar"),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text("Kişisel"), //todo
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                onPressed: (value) {},
                leading: Icon(Icons.person),
                title: Text("Hesap"),
                value: Text(_user!.email.toString()),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Ortak'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.download),
                title: Text('Geçmiş Çıktısı'),
                onPressed: (context) {
                  createExcel();
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.dangerous),
                title: Text('Karaliste'),
                onPressed: (context) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BlackListPage()));
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Dil'),
                value: Text('İngilizce'),
              ),
              SettingsTile.switchTile(
                initialValue: _toggle,
                onToggle: (bool value) {
                  setState(() {
                    _toggle = value;
                  });
                },
                leading: Icon(Icons.notifications),
                title: Text('Bildirimleri Aktif Et'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.exit_to_app),
                title: Text('Çıkış'),
                onPressed: (context) {
                  _authService.signOut();
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                  _user = null;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> createExcel() async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.getRangeByName('A1').setText('Hello World!');
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  if (kIsWeb) {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'Output.xlsx')
      ..click();
  } else {
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
