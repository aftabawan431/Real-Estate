import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:propertyapp/LogInScreen.dart';
import 'package:propertyapp/housePicScreen.dart';
import 'package:propertyapp/main.dart';

import 'HomePage.dart';
class ChooseHome extends StatefulWidget {
final maximumPrice;
final minimumPrice;
final roomNumber;
final bathRoomsNum;
ChooseHome({this.maximumPrice,this.minimumPrice,this.roomNumber,this.bathRoomsNum});
  @override
  _ChooseHomeState createState() => _ChooseHomeState();
}

class _ChooseHomeState extends State<ChooseHome> {
  bool _loading=true;
  String? _Province;
  String? _City;
  String? _Town;
  List<String> _provinces=[];
  List<String> _city=[];
  List<String> _town=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(widget.bathRoomsNum) ;
    print('bathRooms') ;
    print(widget.bathRoomsNum) ;
    print('bathRooms') ;
  }
  getData()async{
    final responce=await FirebaseFirestore.instance.collection('Provinces').get();
    for(var item in responce.docs){
      _provinces.add(item.data()['name']);

    }
    setState(() {
      _loading=false;
    });
  }
  bool hideTown=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Container(
                  height: 100,
                  width: 100,
                  child: Image.asset( 'assets/placeholder.png')) ),
              SizedBox(height: 30,),

              DropdownButton<String>(
                iconEnabledColor: Colors.cyan.withOpacity(.6),
                isExpanded: true,
                itemHeight: 50,
                iconSize: 30,
                hint: Text("Choose Province"),
                items: _provinces
                    .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
                    .toList(),
                value: _Province,
                onChanged: (String? value) async{
                  final respnose=await FirebaseFirestore.instance.collection('city').where('provinceName',isEqualTo: value).get();
                  _city=[];
                  for(var item in respnose.docs){
                    print(item.data());
                    _city.add(item.data()['name']);
                  }
                  
                  print(_Province);
                  setState(() {
                    _city=_city;
                    _Province = value;
                  });
                },
              ),
              SizedBox(height: 20,),

              DropdownButton<String>(
                iconEnabledColor: Colors.cyan.withOpacity(.6),
                isExpanded: true,
                itemHeight: 50,
                iconSize: 30,
                hint: Text("Choose City"),
                items:_city
                    .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ))
                    .toList(),
                value: _City,
                onChanged: (String? value) async{
                  setState(() {
                    _town=[];
                    _Town=null;
                  });
                  print(_town);
                  final respnose=await FirebaseFirestore.instance.collection('town').where('cityName',isEqualTo: value).get();
                  print(respnose.docs);


                  for(var item in respnose.docs){
                    print(item.data());
                    _town.add(item.data()['name']);
                  }
                  print(_town);
                  print(_City);
                  setState(() {

                    _City = value;
                    _town=_town;
                  });
                },
              ),
              SizedBox(height: 20,),
if(true)
              DropdownButton<String>(
                iconEnabledColor: Colors.cyan.withOpacity(.6),
                isExpanded: true,
                itemHeight: 50,
                iconSize: 30,
                hint: Text("Choose Town"),
                items:_town
                    .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                )
                )
                    .toList(),
                value: _Town,
                onChanged: (String? value)async {
                  print(_Town);
                  setState(() {
                    _Town = value;
                  });

                },
              ),
              SizedBox(height: 20,),
              MaterialButton(
                onPressed: (){
               if(_Town!=null && _City!=null && _Province!=null){

                 Navigator.push(context, MaterialPageRoute(builder: (ctx)=>HousepicsScreen(maximumPrice: widget.maximumPrice,minimumPrice: widget.minimumPrice,bathRoomNum: widget.bathRoomsNum,roomNumber: widget.roomNumber,province: _Province,town: _Town,city: _City,)));

               }

                },

                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,


                color: Colors.cyan,

                  child: Text('Next',   style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }
}
