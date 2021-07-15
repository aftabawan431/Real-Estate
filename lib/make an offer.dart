import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:propertyapp/HomePage.dart';
import 'package:propertyapp/page/pdf_viewer_page.dart';
import 'package:propertyapp/paypal/paypalPayments.dart';
import 'package:propertyapp/paypal/paypalPayments2.dart';
import 'package:propertyapp/widgets/button_widget.dart';
import 'package:flutter/services.dart';

import 'api/pdf_api.dart';
import 'package:path/path.dart' as Path;

class MakeOffer extends StatefulWidget {
  final String id;
  MakeOffer(this.id);
  @override
  _MakeOfferState createState() => _MakeOfferState();
}

class _MakeOfferState extends State<MakeOffer> {
  late firebase_storage.Reference ref;
  File? firstFIle;
  File? secondFile;
  bool termLoading=false;
  UploadTask? task;
  File? file;
  bool uploading = false;
  var _paymentController = TextEditingController();
  bool send=false;
  bool agree = false;
  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file,)),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:termLoading?Center(child: CircularProgressIndicator(),): Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children:[ Text('Note:',style: TextStyle(fontSize: 20)),
                  Text('Please enter how much you can pay for this house.'),]
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                    // border: UnderlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'Enter your Price offer',
                  labelStyle: TextStyle(color: Colors.cyan.withOpacity(.7),fontSize: 15),
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.cyan)),
                  prefixIcon: const Icon(
                    Icons.house,
                    color: Colors.green,
                  ),),

                keyboardType: TextInputType.number,
                controller: _paymentController,
              ),
              SizedBox(height: 20,),
              ButtonWidget(
                text: 'Select File 1',
                icon: Icons.attach_file,
                onClicked: ()async{
                  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

                  if (result == null) return;
                  final path = result.files.single.path!;

                  setState(() => firstFIle = File(path));
                },
              ),
              SizedBox(height: 20,),
              ButtonWidget(
                text: 'Select File 2',
                icon: Icons.attach_file,
                onClicked: ()async{
                  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

                  if (result == null) return;
                  final path = result.files.single.path!;

                  setState(() => secondFile = File(path));
                },
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
                      final url = await FirebaseFirestore.instance.collection('pdf').doc('make an offer').get();

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
              if (uploading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              if (!uploading)
              ElevatedButton(
                onPressed: agree ? ()=>uploadFile(context) : null, child: Text('Send'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: TextStyle(
                      // fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),


            ],
          ) ,
        ),
      ),
    );
  }

  Future uplaodFiles(File file) async {

    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('files/${Path.basename(file.path)}');
    await ref.putFile(file);
    String pdfUrl = await ref.getDownloadURL();
    return pdfUrl;

  }
  Future uploadFile(BuildContext context) async {
    if(_paymentController.text.isEmpty || firstFIle==null){
      //show toast
      return     Fluttertoast.showToast(
          msg:
          "Required input is empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }


// setState(() {
//   uploading = true;
// });
    // await FirebaseAuth.instance.currentUser;
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
        builder: (context) => PaypalPayment2(
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

                  String? firstFileUrl='';
                  String? secondFileUrl='';
                  if(firstFIle!=null){
                    firstFileUrl=await uplaodFiles(firstFIle!);

                  }
                  if(secondFile!=null){
                    secondFileUrl=await uplaodFiles(secondFile!);

                  }
                  await FirebaseFirestore.instance.collection("offers").add(
                      {
                        'user': FirebaseAuth
                            .instance.currentUser!.email,
                        'houseId': widget.id,
                        'bitPrice':_paymentController.text,
                        'pdf1':firstFileUrl,
                        'pdf2':secondFileUrl,

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
                      msg: "Done",
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
    );

setState(() {
  uploading = false;
});
Navigator.of(this.context).pop();
// Navigator.of(this.context).pushReplacement(
//     MaterialPageRoute(builder: (ctx) => HomePage(widget.id)));

  }
}
