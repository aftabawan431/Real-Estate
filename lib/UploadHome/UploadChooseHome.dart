import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propertyapp/ViewMore.dart';
import 'package:propertyapp/api/firebase_api.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as Path;
import 'package:propertyapp/api/pdf_api.dart';
import 'package:propertyapp/page/pdf_viewer_page.dart';
import 'package:propertyapp/paypal/paypalPayments.dart';
import 'package:propertyapp/widgets/button_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'UploadMainScreen.dart';

class UploadChooseHome extends StatefulWidget {
  final price;
  final address;
  final roomNumber;
  final bathRoomsNum;
  UploadChooseHome(
      {this.address, this.price, this.roomNumber, this.bathRoomsNum});
  @override
  _UploadChooseHomeState createState() => _UploadChooseHomeState();
}

class _UploadChooseHomeState extends State<UploadChooseHome> {
  bool _loading = true;
  String? _Province;
  String? _City;
  String? _Town;
  List<String> _provinces = [];
  List<String> _city = [];
  List<String> _town = [];
  UploadTask? task;
  File? file;
  File? pdfFile;
  bool agree = false;
  bool termLoading=false;
  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file,)),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(widget.address);
    print(widget.price);
    print(widget.bathRoomsNum);
    print('bathRooms');
    print(widget.bathRoomsNum);
    print('bathRooms');
    // imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }

  getData() async {
    final responce =
        await FirebaseFirestore.instance.collection('Provinces').get();
    for (var item in responce.docs) {
      _provinces.add(item.data()['name']);
    }
    setState(() {
      _loading = false;
    });
  }

  bool hideTown = false;
  bool uploading = false;
  double val = 0;
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

  List<File> _image = [];
  final picker = ImagePicker();

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile!.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadImages(File file) async {

      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(file.path)}');
      await ref.putFile(file);
      String ImageUrl = await ref.getDownloadURL();
      return ImageUrl;

  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Upload Property"),
        backgroundColor: Colors.cyan,
      ),
      body: termLoading?Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyan),
        ),
      )
            :Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                        height: 80,
                        width: 100,
                        child: Image.asset('assets/placeholder.png'))),
                SizedBox(
                  height: 30,
                ),
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
                  onChanged: (String? value) async {
                    final respnose = await FirebaseFirestore.instance
                        .collection('city')
                        .where('provinceName', isEqualTo: value)
                        .get();
                    _city = [];
                    for (var item in respnose.docs) {
                      print(item.data());
                      _city.add(item.data()['name']);
                    }

                    print(_Province);
                    setState(() {
                      _city = _city;
                      _Province = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                  iconEnabledColor: Colors.cyan.withOpacity(.6),
                  isExpanded: true,
                  itemHeight: 50,
                  iconSize: 30,
                  hint: Text("Choose City"),
                  items: _city
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  value: _City,
                  onChanged: (String? value) async {
                    setState(() {
                      _town = [];
                      _Town = null;
                    });
                    print(_town);
                    final respnose = await FirebaseFirestore.instance
                        .collection('town')
                        .where('cityName', isEqualTo: value)
                        .get();
                    print(respnose.docs);

                    for (var item in respnose.docs) {
                      print(item.data());
                      _town.add(item.data()['name']);
                    }
                    print(_town);
                    print(_City);
                    setState(() {
                      _City = value;
                      _town = _town;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (true)
                  DropdownButton<String>(
                    iconEnabledColor: Colors.cyan.withOpacity(.6),
                    isExpanded: true,
                    itemHeight: 50,
                    iconSize: 30,
                    hint: Text("Choose Town"),
                    items: _town
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    value: _Town,
                    onChanged: (String? value) async {
                      print(_Town);
                      setState(() {
                        _Town = value;
                      });
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                  text: 'Select pdf of house',
                  icon: Icons.attach_file,
                  onClicked:()async{
                    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

                    if (result == null) return;
                    final path = result.files.single.path!;

                    setState(() => pdfFile = File(path));
                  }
                ),
                SizedBox(
                  height: 20,
                ),
                Wrap(
                  children: [Text('Your first image will be your main image')],
                ),
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: _image.length + 1,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Center(
                                        child: Column(
                                          children: [
                                            Text('Choose images'),
                                            IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () => !uploading
                                                    ? chooseImage()
                                                    : null),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: FileImage(
                                                    _image[index - 1]),
                                                fit: BoxFit.cover)),
                                      );
                              }),
                        ),
                        uploading
                            ? Center(
                                child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: Text(
                                      'uploading...',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircularProgressIndicator(
                                    value: val,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.green),
                                  )
                                ],
                              ))
                            : Container(),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Wrap(
                  alignment:WrapAlignment.start,
                  crossAxisAlignment:WrapCrossAlignment.center,

                  children: [
                    Checkbox(
                      activeColor: Colors.red,
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = value!;
                        });
                      },
                    ),
                    Text(
                      'I have read and accept',
                      overflow: TextOverflow.ellipsis,
                    ),

                    TextButton(onPressed: ()async{
                      setState(() {
                        termLoading=true;
                      });
                      final url = await FirebaseFirestore.instance.collection('pdf').doc('salepurchase').get();

                      print(url.data());
                      final file = await PDFApi.loadNetwork(url['pdf']);
                      print(file);
                      setState(() {
                        termLoading=false;
                      });

                      if (file == null) return;
                      openPDF(context, file);
                    },
                        child: Text('terms')),
                    Text(
                      'and',
                    ),Text(
                      'conditions',
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: agree ? () async {
                    if( pdfFile ==null ||_Town==null || _City==null || _Province==null || pdfFile==null ||_image.length<4  ){
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
                      Fluttertoast.showToast(
                          msg:
                          "wait for successful message alert\nafter payment",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      var payment = await FirebaseFirestore.instance
                          .collection('payment')
                          .doc('dollar')
                          .get();

                      final dollar = payment.data()!['price'];
                      print(dollar);
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PaypalPayment(
                            onFinish: (number) async {
// payment done
                              print('order id: ' + number);
                              if (number.length > 0) {
                                User? user =
                                await FirebaseAuth.instance.currentUser;
                                QuerySnapshot dollarResponse = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where("user", isEqualTo: user!.email)
                                    .get();
                                final dollars =
                                dollarResponse.docs[0].data()['dollars'];
                                final docId = dollarResponse.docs[0].id;
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(docId)
                                    .update({'dollars': 1});
                                print("xxxxx");

                                String? pdfFileUrl='';

                                if(pdfFileUrl!=null){

                                  pdfFileUrl=await Upload(pdfFile!);

                                }

                                // final pdflink= await Upload();
                                // print("waseem");
                                List imagesLink=[];
                                for(File item in _image){
                                  var url=  await uploadImages(item);
                                  print('loo url ${url}');
                                  imagesLink.add({'img':url.toString()});
                                  print(imagesLink);
                                }
                                await FirebaseFirestore.instance.collection("house").add(
                                    {
                                      "address" : widget.address,
                                      "bathrooms" : widget.bathRoomsNum,
                                      "city" : _City,
                                      "documents":pdfFileUrl,
                                      "price":widget.price,
                                      "province":_Province,
                                      "rooms":widget.roomNumber,
                                      "town":_Town,
                                      'images':imagesLink,

                                    });
                                final response = await FirebaseFirestore.instance
                                    .collection('users')
                                    .where("user", isEqualTo: user.email)
                                    .get();
                                final userDollar = response.docs[0].data()['dollars'];
                                final diD = response.docs[0].id;
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(diD)
                                    .update({'dollars': 0});
                                print("aftab");

                                Fluttertoast.showToast(
                                    msg: "Uploaded",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }else{
                                Fluttertoast.showToast(
                                    msg:
                                    "Error",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 2,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }

// Navigator.of(this.context).pop();

                            },
                            amount: '${dollar}',
                          ),
                        ),
                      ); // Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                     await Navigator.of(this.context).pushReplacement(MaterialPageRoute(builder: (ctx)=>UploadMainScreen()));

                  }:null,
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  color: Colors.cyan,
                  child: Text('Upload',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future Upload( File file) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files/${Path.basename(file.path)}');
    await ref.putFile(file);
    String pdfUrl = await ref.getDownloadURL();
    return pdfUrl;
  }
}
