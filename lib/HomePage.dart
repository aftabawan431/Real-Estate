import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:propertyapp/comments_screen.dart';
import 'package:propertyapp/make%20an%20offer.dart';
import 'package:propertyapp/page/pdf_viewer_page.dart';

import 'LogInScreen.dart';
import 'api/pdf_api.dart';

class HomePage extends StatefulWidget {
  final String id;
  HomePage(this.id);
  static final String title = 'PDF Viewer';
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  var _nameController = TextEditingController();
  var _commnetController = TextEditingController();
  bool canRate = false;
  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file,)),
  );
  List<String> _images = [];
  DocumentSnapshot? house;
  bool _pdfLoading=false;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

String Houseaddress='';
  bool _loading = true;
  getData() async {
    print('here');
    house = await FirebaseFirestore.instance
        .collection('house')
        .doc(widget.id)
        .get();

    User? user = FirebaseAuth.instance.currentUser;
    final response = await FirebaseFirestore.instance
        .collection('reviews')
        .where('houseId', isEqualTo: house!.id)
        .where('user', isEqualTo: user?.email)
        .get();
    if (response.docs.length == 0) {
      setState(() {
        canRate = true;
      });
    }
    print(house!.data());


    setState(() {
      _loading = false;
    });
    // final docref=await  FirebaseFirestore.instance.collection('house').where('address',isEqualTo: house!.id).get();
    // final address = await docref;
    // print(address);



  }
gethouseaddress()async{

  await FirebaseFirestore.instance.collection("house").doc(widget.id).get().then((value){
    final address=value.data()!['address'];
    print(address);
    setState(() {
      Houseaddress=address;
    });
  });
}
  var rating = 3.0;
  Future dollarFunction() async {
    User? user = await FirebaseAuth.instance.currentUser;
    print(user!.email);
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .where('user', isEqualTo: user.email)
        .get();
    print(docRef.docs[0].data());
    final dollars = docRef.docs[0].data()['dollars'];
    print('start========>');
    print(dollars);
    print('end');
    if (dollars > 0) {
      print('true triggered');
      return true;
    } else {
      print('false triggered');
      return false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    gethouseaddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
              )
            : Container(
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  await _signOut();

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              LoginScreen(widget.id)));
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.cyan,
                                    textStyle: TextStyle(
                                        // fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                child: Text("SignOut")),
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        child: CarouselSlider(
                          options: CarouselOptions(height: 300.0),
                          items: house!.data()!['images'].map<Widget>((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    decoration:
                                        BoxDecoration(color: Colors.amber),
                                    child: Image.network(
                                      i['img'],
                                      fit: BoxFit.cover,
                                    ));
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                Wrap(
                  children: [
                    Text('Address: ',style: GoogleFonts.openSans(
                        color: Colors.black, fontSize: 20),),
                    Text('$Houseaddress',style: GoogleFonts.openSans(
                    color: Colors.black, fontSize: 15),),
                  ],
                ),
                      SizedBox(
                        height: 10,
                      ),
                      if (canRate == true)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rate the House:',
                              style: GoogleFonts.openSans(
                                  color: Colors.black, fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {
                                rating = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter your username'
                              ),
                              controller: _nameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter your comment'
                              ),
                              controller: _commnetController,
                            ),
                            TextButton(
                                onPressed: () async {
                                  if(_commnetController.text.length>0 && _nameController.text.length>0)
                                    {
                                      await FirebaseFirestore.instance
                                          .collection('reviews')
                                          .add({
                                        'user': FirebaseAuth
                                            .instance.currentUser!.email,
                                        'rating': rating,
                                        'comment': _commnetController.text,
                                        'name': _nameController.text,
                                        'houseId': house!.id
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('house')
                                          .doc(house!.id)
                                          .update({
                                        'rating': FieldValue.increment(rating),
                                        'totalRating': FieldValue.increment(1),
                                      });
                                      setState(() {
                                        canRate = false;
                                      });
                                    }

                                },
                                child: Text("Submit",style: TextStyle(color: Colors.cyan),))
                          ],
                        ),
                      TextButton(
                        onPressed: ()async {

                          Navigator.of(context).push(MaterialPageRoute(builder: (c)=>CommentsScreen(house!.id)));
                        },
                        child: Text("See Commnets",style: TextStyle(color: Colors.cyan)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (_pdfLoading)
                        Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.cyan),
                          ),
                        ),
                      if (!_pdfLoading)
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                               _pdfLoading=true;
                            });
                            final url = house!.data()!['documents'];
                            print(url);
                            final file = await PDFApi.loadNetwork(url);
                            print(file);

                            if (file == null) return;
                            openPDF(context, file);
                            setState(() {
                               _pdfLoading=false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.cyan,
                              textStyle: TextStyle(
                                  // fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          child: Text("Documents")),
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(builder: (c)=>MakeOffer(house!.id)));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              textStyle: TextStyle(
                                // fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          child: Text("Make an offer")),
                    ],
                  ),
                ),
              ));
  }

}
