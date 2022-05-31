import 'package:kelebike/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelebike/service/auth.dart';
import 'package:kelebike/utilities/constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _passswordAgainController = TextEditingController();
  var _CheckBoxController = TextEditingController();
  bool _validatePass = false;
  AuthService _authService = AuthService();
  bool isChecked = false;
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Color(0xFF6CA8F1),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xFF6CA8F1),
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              color: Color(0xFF6CA8F1),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFF6CA8F1),
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordAgainTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passswordAgainController,
            obscureText: true,
            style: TextStyle(
              color: Color(0xFF6CA8F1),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFF6CA8F1),
              ),
              hintText: 'Enter your Password Again',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Future navigateToSubPage(context) async {
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Widget _buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          print("pressed");
          if (isChecked) {
            if (_passwordController.text == _passswordAgainController.text &&
                _emailController.text.contains('@gtu.edu.tr') &&
                _passwordController.text.length >= 6) {
              _authService
                  .createPerson(_emailController.text, _passwordController.text)
                  .then((value) {
                if (value == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Welcome to Kelebike"),
                        content: new Text(
                            "Verify email has been sent your email. Please check it!"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              navigateToSubPage(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Account couln't be created"),
                    content: new Text(
                        "Requirements:\n\t\t\t-Mail address must have @gtu.edu.tr extension.\n\t\t\t-Password must be at least 6 characters."),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Warning!"),
                  content: new Text("You have accept the bike delivery terms."),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildCheckBox() {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 60,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Color(0xFF527DAA),
        activeColor: Colors.white,
        value: isChecked,
        onChanged: (isChecked) {
          setState(() {
            this.isChecked = isChecked!;
            if (isChecked == true) {
              String textFromFile;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.only(left: 25, right: 25),
                    title: Center(child: Text("Bicycle Delivery Record")),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    content: Container(
                      height: 300,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                                "I received the bike, which was given by the Department of Health and Sports Bicycle Unit and registered its brand, model and serial number, completely and intact."),
                            Text(
                              "Bicycle Delivery Terms",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "1- The temporary allocation period for bicycle use is 5 (five) working days. In case the usage period is extended, the registration renewal process will be done again. The person who does not do this will not be given a bike again. Bicycles will be delivered to the Bicycle Unit of the Department of Health, Culture and Sports."),
                            Text(
                                "2- The student/staff can only buy the bike in their own name. It is forbidden to buy a bicycle and make transactions on behalf of another person. Can only take one bike for own use"),
                            Text(
                                "3- The student/staff will deliver the received bike, complete with all its accessories, in good condition and in working condition, on the date of delivery."),
                            Text(
                                "4- Student/staff cannot lend, rent or sell the bicycle they have received to a third party."),
                            Text(
                                "5- The student/staff is responsible for the safety of the bicycle they receive. He is obliged to compensate for the value of the lost bike or to replace it with a new one of equal value."),
                            Text(
                                "6- Students/staff will use it in accordance with the Bicycle Usage Rules directive and Safe Cycling Guidelines in Cities.."),
                            Text(
                                "7- In cases where it is determined to be caused by user error, all expenses related to accidents and all kinds of material and moral damages, all kinds of malfunctions and repair expenses that may occur in bicycles due to use that are not in accordance with the driving rules and safety explanations and the rules in the Safe Cycling User's Guide in Cities are collected from the user. will be. Action is taken in accordance with the relevant legislation and directive.")
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          });
        },
        title: Text(
          'I have accept the bike delivery terms.',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () => navigateToSubPage(context),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'You have already an account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 74, 148, 231),
                      Color.fromARGB(255, 85, 153, 230),
                      Color.fromARGB(255, 104, 163, 231),
                      Color.fromARGB(255, 193, 213, 236),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(height: 30.0),
                      _buildPasswordTF(),
                      _buildPasswordAgainTF(),
                      SizedBox(
                        height: 25.0,
                      ),
                      _buildCheckBox(),
                      _buildSignUpBtn(),
                      _buildLoginBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
