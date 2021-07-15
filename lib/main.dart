import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'ViewMore.dart';
import 'ChooseHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/a':(ctx)=>ViewMore(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
        hintColor: Colors.cyan,

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

int minPrice = 0;
int maxPrice = 15;
int roomNum = 5;
int bathRooms = 3;

// class MyHomePage extends StatefulWidget {
//   @override
//   // SplashScreenState createState() => SplashScreenState();
// }
//
// class SplashScreenState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(
//         Duration(seconds: 5),
//         () => Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => HomeScreen())));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 120,
//         width: 120,
//         color: Colors.white,
//         child: Image.asset('assets/logo.png'));
//   }
// }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Booking Property"),
          backgroundColor: Colors.cyan,
        ),
        body: DoubleBack(
          message:"Press back again to close",
          child: Container(
            // color: Color(	0xfffffbee),
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
                        'Please enter desire price of House:',
                        style: GoogleFonts.openSans(
                            color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Min ',
                            style: GoogleFonts.openSans(
                                color: Colors.black, fontSize: 20),
                            // style: knumbertextstyle,
                          ),
                          Text(
                            minPrice.toString(),
                            style: GoogleFonts.openSans(
                                color: Colors.black, fontSize: 20),
                            // style: knumbertextstyle,
                          ),
                          Text(
                            ' Lac NZ\$',
                            // style: klabeltext,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Color(0xFF8D8E98),
                          thumbColor: Color(0xFFEB1555),
                          overlayColor: Color(0x290EB1555),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 25.0),
                        ),
                        child: Slider(
                          value: minPrice.toDouble(),
                          min: 0.0,
                          max: 120.0,
                          inactiveColor: Colors.grey,
                          onChanged: (double newValue) {
                            setState(() {
                              minPrice = newValue.round();
                            });
                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Max ',
                            style: GoogleFonts.openSans(
                                color: Colors.black, fontSize: 20),
                            // style: knumbertextstyle,
                          ),
                          Text(
                            maxPrice.toString(),
                            style: GoogleFonts.openSans(
                                color: Colors.black, fontSize: 20),
                            // style: knumbertextstyle,
                          ),
                          Text(
                            ' Lac NZ\$',
                            // style: klabeltext,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Color(0xFF8D8E98),
                          thumbColor: Color(0xFFEB1555),
                          overlayColor: Color(0x290EB1555),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 25.0),
                        ),
                        child: Slider(
                          value: maxPrice.toDouble(),
                          min: 0.0,
                          max: 120.0,
                          inactiveColor: Colors.grey,
                          onChanged: (double newValue) {
                            setState(() {
                              maxPrice = newValue.round();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        'Enter total number of bedrooms:',
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
                        'Enter total number of Bathrooms:',
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ViewMore()));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'View More',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_up_sharp,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                              color:  Color(0xFFEB1555),
                              height: 45,
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => ChooseHome(maximumPrice: maxPrice,minimumPrice: minPrice,roomNumber: roomNum,bathRoomsNum: bathRooms ,)));
                              },
                              child: Row(
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

                          ],
                        ),
                      )
                    ],
                  ),
                ]),
          ),
        ));
  }
}
