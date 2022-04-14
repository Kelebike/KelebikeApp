import 'package:firebase_auth/firebase_auth.dart';
import 'package:kelebike/screens/admin_bikes_screen.dart';
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
        title: Text("Admin Panel"),
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
                MaterialPageRoute(builder: (context) => RequestScreen()));
          }
        },
        child: Icon(Icons.call_received),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Welcome admin!"),
              accountEmail: Text(_user!.email.toString()),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 243, 92, 4).withOpacity(1.0)),
            ),
            ListTile(
              title: Text('Homepage'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Bikes'),
              leading: Icon(Icons.pedal_bike),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminBikesScreen()));
              },
            ),
            ListTile(
              title: Text('Requests'),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestScreen()));
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
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                width: double.infinity,
                height: 100,
                decoration: kBoxDecorationStyle,
                padding: new EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.pedal_bike, color: Colors.white),
                    new Text(
                      'Total Bicycle: ',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              new Container(
                width: double.infinity,
                height: 100,
                decoration: kBoxDecorationStyle,
                padding: new EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.info, color: Colors.white),
                    new Text(
                      'Number Of Request:',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              new Container(
                width: double.infinity,
                height: 100,
                decoration: kBoxDecorationStyle,
                padding: new EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.autorenew, color: Colors.white),
                    new Text(
                      'Bicycles In Circulation:',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              new Container(
                width: double.infinity,
                height: 100,
                decoration: kBoxDecorationStyle,
                padding: new EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.build,
                      color: Colors.white,
                    ),
                    new Text(
                      'Bicycles In Renovation:',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
