import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/model/bike.dart';
import 'package:kelebike/screens/admin_bikes_screen.dart';
import 'package:kelebike/screens/admin_info_page.dart';
import 'package:kelebike/screens/admin_requests_screen.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:kelebike/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/screens/take_bike_page.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/service/bike_service.dart';
import 'package:kelebike/utilities/constants.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  AuthService _authService = AuthService();
  bool _rememberMe = false;
  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    BikeService _bikeService = BikeService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        title: const Text("Admin Panel"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 243, 92, 4),
        onPressed: () async {
          if (await _bikeService.findWithMail(_user!.email.toString()) == 1) {
            showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                      title: const Text('Error'),
                      content: Text('You already have a request.'),
                    ));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RequestScreen()));
          }
        },
        child: const Icon(Icons.call_received),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text("Welcome admin!"),
              accountEmail: Text(_user!.email.toString()),
              decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 243, 92, 4).withOpacity(1.0)),
            ),
            ListTile(
              title: const Text('Homepage'),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bikes'),
              leading: const Icon(Icons.pedal_bike),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminBikesScreen()));
              },
            ),
            ListTile(
              title: const Text('Requests'),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestScreen()));
              },
            ),
            ListTile(
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
              },
              leading: const Icon(Icons.history),
            ),
            const Divider(),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                _authService.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                _user = null;
              },
              leading: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: AdminInfoPage(),
    );
  }
}
