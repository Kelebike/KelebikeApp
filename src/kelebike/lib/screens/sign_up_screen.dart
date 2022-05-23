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
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
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
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
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
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
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
                    title: Center(child: Text("Bisklet Teslim Tutanağı")),
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
                                "Sağlık ve Spor Dairesi Başkanlığı Bisiklet Birimi tarafından verilen ve markası, modeli ve seri numarası kayıtlı bisikleti eksiksiz ve sağlam olarak teslim aldım.Bakım, onarım veya sayım gibi nedenlerle istenilen tarihte aldığım şekilde teslim edeceğim."),
                            Text(
                              "Bisiklet Teslim Şartları",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                "1- Bisiklet kullanımı için geçici tahsis süresi 5 (beş) iş günüdür. Kullanım süresinin uzatılması durumunda kayıt yenileme işlemi tekrar yapılacaktır.  Bu işlemi yapmayan kişiye bir daha bisiklet verilmeyecektir. Bisikletler Sağlık, Kültür ve Spor Dairesi Başkanlığı Bisiklet Birimine eksiksiz teslim edilecektir"),
                            Text(
                                "2- Öğrenci/personel bisikleti ancak kendi adına alabilir. Bir başka kişi adına bisiklet alınması ve işlem yapılması yasaktır. Kendi kullanımı için sadece bir bisiklet alabilir"),
                            Text(
                                "3- Öğrenci/personel teslim aldığı bisikleti teslim edeceği tarihte tüm aksesuarları ile eksiksiz, sağlam ve çalışır durumda teslim edecektir"),
                            Text(
                                "4- Öğrenci/personel teslim aldığı bisikleti üçüncü bir şahsa ödünç veremez, kiralayamaz veya satamaz"),
                            Text(
                                "5- Öğrenci/personel teslim aldığı bisikletin güvenliğinden sorumludur. Kaybolan bisikletin değerini tazmin etmek ya da yerine eş değerde yenisini alıp teslim etmekle yükümlüdür."),
                            Text(
                                "6- Öğrenci/personelin Bisiklet Kullanım Kuralları yönergesi ve Şehirlerde Güvenli Bisiklet Kullanma Kılavuzu kurallarına göre uygun kullanacaktır."),
                            Text(
                                "7- Kullanıcı hatasından kaynaklandığı tespit edilen durumlarda sürüş kuralları ve güvenlik açıklamalarına ve “Şehirlerde Güvenli Bisiklet Kullanma Kılavuzu”ndaki kurallara uygun olmayan kullanımlardan dolayı oluşacak kazalar ve her türlü maddi, manevi zararlar, bisikletlerde meydana gelebilecek her türlü arıza ve onarım giderleri ile ilgili tüm masraflar kullanıcıdan tahsil edilecektir.  Hakkında ilgili mevzuat ve yönerge uyarınca işlem yapılır.")
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
          'I have read and accept the bike delivery terms.',
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
