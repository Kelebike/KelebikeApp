import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/service/localization_service.dart';
import 'package:kelebike/utilities/constants.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

String currentLanguage(String lang) {
  if (lang == "tr") {
    return "Türkçe";
  } else if (lang == "en") {
    return "English";
  } else
    return "Change language";
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? _user = FirebaseAuth.instance.currentUser;
  AuthService _authService = AuthService();
  final localizationController = Get.find<LocalizationController>();
  bool _toggle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6CA8F1),
        elevation: 0,
        title: Text(
          LocalizationService.of(context).translate('settings')!,
        ),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text("Personal"), //todo
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                onPressed: (value) {},
                leading: Icon(Icons.person),
                title: Text("Account"), //todo
                value: Text(_user!.email.toString()),
              ),
            ],
          ),
          SettingsSection(
            title: Text(LocalizationService.of(context).translate('common')!),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                onPressed: (value) {
                  localizationController.toggleLanguage();
                },
                leading: Icon(Icons.language),
                title: Text(
                    LocalizationService.of(context).translate('language')!),
                value: Text(currentLanguage(
                    localizationController.currentLanguage.toString())),
              ),
              SettingsTile.switchTile(
                initialValue: _toggle,
                onToggle: (bool value) {
                  setState(() {
                    _toggle = value;
                  });
                },
                leading: Icon(Icons.notifications),
                title: Text(
                    LocalizationService.of(context).translate('enable_not')!),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.exit_to_app),
                title: Text(
                    LocalizationService.of(context).translate('sign_out')!),
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
