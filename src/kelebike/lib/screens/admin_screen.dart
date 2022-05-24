import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/model/bike.dart';
import 'package:kelebike/screens/admin_bikes_screen.dart';
import 'package:kelebike/screens/admin_info_page.dart';
import 'package:kelebike/screens/admin_requests_screen.dart';
import 'package:kelebike/screens/admin_return_screen.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:kelebike/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/screens/take_bike_page.dart';
import 'package:kelebike/screens/admin_settings.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:kelebike/utilities/constants.dart';
import 'admin_history_screen.dart';

import 'admin_history_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  AuthService _authService = AuthService();
  bool _rememberMe = false;

  int index = 2;

  final screens = [
    AdminHistoryScreen(),
    AdminBikesScreen(),
    AdminInfoPage(),
    RequestScreen(),
    AdminSettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    BikeService _bikeService = BikeService();

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.orange.shade100,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            )),
        child: NavigationBar(
          height: 60,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          animationDuration: Duration(milliseconds: 500),
          selectedIndex: index,
          onDestinationSelected: (int index) =>
              setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: 'History'),
            NavigationDestination(
                icon: Icon(Icons.pedal_bike),
                selectedIcon: Icon(Icons.pedal_bike),
                label: 'Bikes'),
            NavigationDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home_outlined),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.call_received),
                selectedIcon: Icon(Icons.call_received),
                label: 'Requests'),
            NavigationDestination(
                icon: Icon(Icons.settings),
                selectedIcon: Icon(Icons.settings_outlined),
                label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
