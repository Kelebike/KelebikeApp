import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/admin_add_bike_page.dart';
import 'package:kelebike/screens/admin_requests.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/custom_tab_bar.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';

import 'admin_return_request.dart';
import 'admin_take_request.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  int _currentPageIndex = 0;
  PageController _pageViewController = PageController(initialPage: 0);
  List<Widget> get _pages => [TakeRequest(), ReturnRequest()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6CA8F1),
        elevation: 0,
        title: Text("Requests"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          CustomTabBar(index: _currentPageIndex),
          Expanded(
            child: PageView.builder(
              itemCount: _pages.length,
              controller: _pageViewController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return _pages[index];
              },
            ),
          )
        ],
      ),
    );
  }
}
// Requests() request sekmesinde gidecek
