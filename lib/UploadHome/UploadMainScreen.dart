import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propertyapp/UploadHome/UploadChooseHome.dart';


int minPrice = 0;
int maxPrice = 15;
int roomNum = 2;
int bathRooms = 1;


class UploadMainScreen extends StatefulWidget {
  @override
  _UploadMainScreenState createState() => _UploadMainScreenState();
}

class _UploadMainScreenState extends State<UploadMainScreen> {
  var _priceController = TextEditingController();
  var _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Property"),
          backgroundColor: Colors.cyan,
        ),
        body: Container(
          // color: Color(	0xfffffbee),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Welcome to My Street app",
                      style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Please upload desire price of House:',
                        style: GoogleFonts.openSans(
                            color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          decoration: InputDecoration(
                            // border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Enter Price in NZ dollars',
                            labelStyle: TextStyle(color: Colors.cyan.withOpacity(.7),fontSize: 15),
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.cyan)),
                            prefixIcon: const Icon(
                              Icons.house,
                              color: Colors.green,
                            ),),

                          keyboardType: TextInputType.number,
                          controller: _priceController,
                        ),
                       ),

                      Text(
                        'Upload total number of bedrooms:',
                        style: GoogleFonts.openSans(
                            color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (roomNum > 1) {
                                  setState(() {
                                    roomNum = roomNum - 1;
                                  });
                                }
                              },
                              icon: Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Icon(Icons.minimize, color: Colors.grey),
                              )),
                          Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black12, width: 1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: 60,
                              height: 40,
                              child: Center(
                                  child: Text(
                                    "${roomNum}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 22),
                                  )),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  roomNum = roomNum + 1;
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.grey,
                              )),

                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Upload total number of Bathrooms:',
                        style: GoogleFonts.openSans(
                            color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (bathRooms > 1) {
                                  setState(() {
                                    bathRooms = bathRooms - 1;
                                  });
                                }
                              },
                              icon: Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Icon(Icons.minimize, color: Colors.grey),
                              )),
                          Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black12, width: 1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: 60,
                              height: 40,
                              child: Center(
                                  child: Text(
                                    "${bathRooms}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400, fontSize: 22),
                                  )),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  bathRooms = bathRooms + 1;
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.grey,
                              )),

                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Upload Address of your house:',
                        style: GoogleFonts.openSans(
                            color: Colors.black, fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          decoration: InputDecoration(
                            // border: UnderlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Hint:House No#22 Near Capital College',
                            labelStyle: TextStyle(color: Colors.cyan.withOpacity(.7),fontSize: 15),
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.cyan)),
                            prefixIcon: const Icon(
                              Icons.house,
                              color: Colors.green,
                            ),),

                          keyboardType: TextInputType.text,
                          controller: _addressController,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: MaterialButton(
                          onPressed: () {
                            if( _addressController.text.isEmpty || _priceController.text.isEmpty  ){
                              //show toast
                              Fluttertoast.showToast(
                                  msg:
                                  "Required input is empty",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                              return     ;
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => UploadChooseHome(address:_addressController.text,price: _priceController.text,roomNumber: roomNum,bathRoomsNum: bathRooms ,)));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save and Next',
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                          color: Colors.cyan,
                          height: 45,
                        ),
                      )
                    ],
                  ),
                ]),

    )));
  }
}
