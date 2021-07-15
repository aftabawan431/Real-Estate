import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propertyapp/LogInScreen.dart';

class HousepicsScreen extends StatefulWidget {
  final maximumPrice;
  final minimumPrice;
  final roomNumber;
  final province;
  final town;
  final city;
  final bathRoomNum;
  HousepicsScreen(
      {this.bathRoomNum,
        this.roomNumber,
      this.city,
      this.maximumPrice,
      this.minimumPrice,
      this.province,
      this.town});

  @override
  _HousepicsScreenState createState() => _HousepicsScreenState();
}

class _HousepicsScreenState extends State<HousepicsScreen> {
  bool _imgLoaidng=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.roomNumber);
    print(widget.maximumPrice);
    print(widget.city);
    print(widget.town);
    print('bathRooms') ;
    print(widget.town);
    print('bathRooms') ;
    print(widget.bathRoomNum) ;
   print(widget.province);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "These are Houses in the Town:",
                style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('house')
                      .where('province', isEqualTo: widget.province)
                      .where('city', isEqualTo: widget.city)
                      .where('town', isEqualTo: widget.town)
                      .where('price', isGreaterThanOrEqualTo:( widget.maximumPrice *100000).toString())
                      .where('rooms', isEqualTo: widget.roomNumber)
                      .where('bathrooms', isEqualTo: widget.bathRoomNum)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                     if(snapshot.data!.docs.length==0){
                       return Center(child: Text('No houses found'),);
                     }
                      return ListView.builder(

                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            print(snapshot.data!.docs[index]);
                            return Card(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => LoginScreen( snapshot.data!.docs[0].id)));
                                },
                                child: _imgLoaidng?CircularProgressIndicator():Container(
                                  color: Colors.grey,
                                  height: 150,
                                  child: Image.network(
                                    snapshot.data!.docs[0].data()['images'][0]
                                        ['img'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
