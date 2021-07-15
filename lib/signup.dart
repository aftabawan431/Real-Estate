import 'package:propertyapp/HomePage.dart';
import 'package:propertyapp/LogInScreen.dart';

import 'FadeAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum _handleGenderChange{_formData}

class SignupScreen extends StatefulWidget {
  final String id;
  SignupScreen(this.id);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final Color primaryColor = Colors.white;

  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Colors.cyan;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String email='';
  String password='';
  bool showSpinner=false;
  bool _RegisterLoading= false;
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
            body:
            Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                     FadeAnimation(1, Text(
                        'Sign up and continue',
                        textAlign: TextAlign.center,
                        style:
                        GoogleFonts.openSans(color: Colors.black, fontSize: 28),
                      ),),
                      SizedBox(height: 20),
                      FadeAnimation(1, Text(
                        'Enter your email and password below to continue to My Street and let the Booking begin!',
                        textAlign: TextAlign.center,
                        style:
                        GoogleFonts.openSans(color: Colors.black, fontSize: 14),
                      ),),
                      SizedBox(
                        height: 50,
                      ),
                      _buildTextField(
                          nameController, Icons.account_circle, 'Username@gmail.com',false),
                      SizedBox(height: 20),
                      _buildTextField(passwordController, Icons.lock, 'Password(must be 6 characters)',true),
                      SizedBox(height: 30),
                      if(_RegisterLoading)
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff25bcbb)),

                        ),
                      if(!_RegisterLoading)
                     FadeAnimation(2, MaterialButton(

                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () async {
                          setState(() {
                          _RegisterLoading=true;
                          });
                          print(nameController.text);
    try{
    if(passwordController.text.length<6){
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text("Error",style: TextStyle(color: Colors.red),),
    content: Text('There is an error during Register'),
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
    }else{
      var user = await _auth.createUserWithEmailAndPassword(
          email: nameController.text,
          password: passwordController.text);
      print(user.user?.uid);
      print(user.user?.email);
      print(password);
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(widget.id)));
    }
    }              catch(e){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error",style: TextStyle(color: Colors.red),),
              content: Text('There is some error in email or password'),
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

                            // }
                            setState(() {
                              showSpinner=false;
                            });

                          setState(() {
                            _RegisterLoading=false;
                          });
                          print(email);
                          print(password);
                        },
                        color: logoGreen,
                        child: Text('Register',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                        textColor: Colors.white,
                      ),),
                      SizedBox(height: 30),


                      SizedBox(height: 100),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildFooterLogo(),
                      )
                    ],
                  ),
                ),
              ),
            ));
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
      String labelText,bool obscureText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: primaryColor, border: Border.all(color: Colors.cyan)),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(

            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black.withOpacity(.7),fontSize: 15),
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