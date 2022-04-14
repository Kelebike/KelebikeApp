import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/bikepage.dart';
import 'package:kelebike/screens/login_screen.dart';
import 'package:kelebike/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/screens/take_bike_page.dart';
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

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    BikeService _bikeService = BikeService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        title: Text("Kelebike"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 243, 92, 4),
        onPressed: () async {
          if (await _bikeService.findWithMail(_user!.email.toString()) == 1) {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('Error'),
                      content: Text('You already have a request.'),
                    ));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TakeBikePage()));
          }
        },
        child: Icon(Icons.directions_bike),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Welcome!"),
              accountEmail: Text(_user!.email.toString()),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 243, 92, 4).withOpacity(1.0)),
            ),
            ListTile(
              title: Text('Bikepage'),
              leading: Icon(Icons.pedal_bike),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
              },
              leading: Icon(Icons.history),
            ),
            Divider(),
            ListTile(
              title: Text('Sign out'),
              onTap: () {
                _authService.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
                _user = null;
              },
              leading: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: BikePage(),
    );
  }
}
