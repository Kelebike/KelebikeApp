import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/admin_return_screen.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:kelebike/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/screens/take_bike_page.dart';
import 'package:kelebike/screens/user_info_page.dart';
import 'package:kelebike/screens/user_returns.dart';
import 'package:kelebike/screens/user_settings.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:kelebike/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService _authService = AuthService();
  bool _rememberMe = false;
  int index = 2;
  int data = 0;

  final screens = [
    HistoryScreen(), //Mail page vs.
    ReturnQRPage(),
    UserInfoPage(),
    TakeBikePage(),
    SettingsScreen(),
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
            onDestinationSelected: (int index) => setState(() {
              this.index = index;
              print(data);
              if (data == 1 && index == 3) {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Error'),
                          content: Text('You already have a request.'),
                        ));
              }
            }),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history),
                  label: 'History'),
              NavigationDestination(
                  icon: Icon(Icons.keyboard_double_arrow_left),
                  selectedIcon: Icon(Icons.keyboard_double_arrow_left),
                  label: 'Return'),
              NavigationDestination(
                  icon: Icon(Icons.home),
                  selectedIcon: Icon(Icons.home_outlined),
                  label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.directions_bike_outlined),
                  selectedIcon: Icon(Icons.directions_bike),
                  label: 'Take a bike'),
              NavigationDestination(
                  icon: Icon(Icons.settings),
                  selectedIcon: Icon(Icons.settings_outlined),
                  label: 'Settings'),
            ],
          ),
        ));
  }
}
