import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';
import 'package:settings_ui/settings_ui.dart';

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
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.switchTile(
                initialValue: _toggle,
                onToggle: (bool value) {
                  setState(() {
                    _toggle = value;
                  });
                },
                leading: Icon(Icons.notifications),
                title: Text('Enable notifications'),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign out'),
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
