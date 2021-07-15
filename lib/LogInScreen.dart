import 'package:propertyapp/UploadHome/UploadMainScreen.dart';

import 'FadeAnimation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'HomePage.dart';

class LoginScreen extends StatefulWidget {
  final String id;
  LoginScreen(this.id);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loginLoaidng = false;
  bool showSpinner = false;
  final Color primaryColor = Colors.white;
  final Color logoGreen = Colors.cyan;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  Future<void> checkIfLoggedIn() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        if (widget.id == 'upload') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => UploadMainScreen()));
        } else
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (ctx) => HomePage(widget.id)));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: primaryColor,
            body: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimation(
                      1,
                      Text(
                        'Sign in and continue',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            color: Colors.black, fontSize: 28),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Enter your email and password below to continue to My Street and let the Booking begin!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 14),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    _buildTextField(nameController, Icons.account_circle,
                        'Username@gmail.com', false),
                    SizedBox(height: 20),
                    _buildTextField(passwordController, Icons.lock,
                        'Password(must be 6 characters)', true),
                    SizedBox(height: 30),
                    if (_loginLoaidng)
                      CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.cyan),
                      ),
                    if (!_loginLoaidng)
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () async {
                          setState(() {
                            _loginLoaidng = true;
                          });
                          print(nameController.text);
                          try {
                            if (passwordController.text.length < 6) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Error",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content: Text(
                                          'There is an error during login'),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: logoGreen, // background
                                            onPrimary:
                                                Colors.white, // foreground
                                          ),
                                          child: Text("Ok"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: nameController.text,
                                      password: passwordController.text);
                              if (user != null) {
                                print(user);
                                print("aftab");
                                if (widget.id == 'upload') {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              UploadMainScreen()));
                                } else {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              HomePage(widget.id)));
                                }
                              }
                            }
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Error",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: Text(
                                        'There is some error in email or password'),
                                    actions: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: logoGreen, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                        child: Text("Ok"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                          print(email);
                          print(password);
                          setState(() {
                            _loginLoaidng = false;
                          });
                        },
                        color: logoGreen,
                        child: Text('Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        textColor: Colors.white,
                      ),
                    SizedBox(height: 30),
                    FadeAnimation(
                      2,
                      MaterialButton(
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () {
                          // Provider.of<DataProvider>(context,listen: false);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (ctx) => SignupScreen(widget.id)));
                        },
                        color: Color(0xff25bcbb),
                        child: Text('Create New Account',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 100),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildFooterLogo(),
                    )
                  ],
                ),
              ),
            )));
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Image.asset(
        //   'assets/72.png',
        //   height: 40,
        // ),
        Text('Welcome To My Street App',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  _buildTextField(TextEditingController controller, IconData icon,
      String labelText, bool obsecuredText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: primaryColor, border: Border.all(color: Colors.cyan)),
      child: TextField(
        obscureText: obsecuredText,
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle:
                TextStyle(color: Colors.black.withOpacity(.7), fontSize: 15),
            icon: Icon(
              icon,
              color: Colors.black,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }
}
