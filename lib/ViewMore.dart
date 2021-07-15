import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:propertyapp/LogInScreen.dart';
import 'package:propertyapp/UploadHome/UploadMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:propertyapp/page/pdf_viewer_page.dart';

import 'api/pdf_api.dart';
class ViewMore extends StatefulWidget {
  final String Uploadid='upload';

  @override
  _ViewMoreState createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  bool ContactLoading=false;
  bool BuilderLoading=false;
  bool BankLoading=false;
  bool InsuranceLoading=false;
  bool BookLoading=false;
  bool OfferLoading=false;

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file,)),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Seller Choose Options'),),backgroundColor: Color(0xFFEB1555)),
        body: ContactLoading|| BankLoading || BuilderLoading || InsuranceLoading ||BookLoading||OfferLoading? Center(
                  child: CircularProgressIndicator(
             valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              ),
             )
        :Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/2'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
             Row(
               children: [
                 Expanded(
                   child: InkWell(
                     onTap: ()async{
                       setState(() {
                         ContactLoading=true;
                       });
                       final contactUrl = await FirebaseFirestore.instance.collection('pdf').doc('contactLawyer').get();

                       print(contactUrl.data());
                       final file = await PDFApi.loadNetwork(contactUrl['pdf']);
                       print(file);
                       setState(() {
                         ContactLoading=false;
                       });

                       if (file == null) return;
                       openPDF(context, file);
                     },
                     child: Container(
                       child: Center(child: Text('Contact Lawyer',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),)),
                       height: 100,
                       margin: EdgeInsets.all(8.0),
                       decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color: Colors.white.withOpacity(0.7),
                             spreadRadius: 6,
                             blurRadius: 2,
                             offset: Offset(
                                 0, 3), // changes position of shadow
                           ),
                         ],
                         color:  Colors.transparent,
                         borderRadius: BorderRadius.circular(8.0),
                       ),
                     ),
                   ),
                 ),

                 Expanded(
                   child: InkWell(
                     onTap: ()async{
                       setState(() {
                         BankLoading=true;
                       });
                       final BankUrl = await FirebaseFirestore.instance.collection('pdf').doc('bank').get();

                       print(BankUrl.data());
                       final file = await PDFApi.loadNetwork(BankUrl['pdf']);
                       print(file);
                       setState(() {
                         BankLoading=false;
                       });

                       if (file == null) return;
                       openPDF(context, file);
                     },
                     child: Container(
                       height: 100,
                       child: Center(child: Text('Bank',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),)),

                       margin: EdgeInsets.all(15.0),
                       decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color: Colors.white.withOpacity(0.7),
                             spreadRadius: 6,
                             blurRadius: 2,
                             offset: Offset(
                                 0, 3), // changes position of shadow
                           ),
                         ],

                         borderRadius: BorderRadius.circular(10.0),
                       ),
                     ),
                   ),
                 )
               ],
             ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        setState(() {
                          BuilderLoading=true;
                        });
                        final builderUrl = await FirebaseFirestore.instance.collection('pdf').doc('Builder').get();

                        print(builderUrl.data());
                        final file = await PDFApi.loadNetwork(builderUrl['pdf']);
                        print(file);
                        setState(() {
                          BuilderLoading=false;
                        });

                        if (file == null) return;
                        openPDF(context, file);
                      },
                      child: Container(
                        height: 100,
                        child: Center(child: Text('Builder',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),)),

                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.7),
                              spreadRadius: 6,
                              blurRadius: 2,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        setState(() {
                          InsuranceLoading=true;
                        });
                        final InsuranceUrl = await FirebaseFirestore.instance.collection('pdf').doc('insurance').get();

                        print(InsuranceUrl.data());
                        final file = await PDFApi.loadNetwork(InsuranceUrl['pdf']);
                        print(file);
                        setState(() {
                          InsuranceLoading=false;
                        });

                        if (file == null) return;
                        openPDF(context, file);
                      },
                      child: Container(
                        height: 100,
                        child: Center(child: Text('Insurance',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),)),

                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.7),
                              spreadRadius: 6,
                              blurRadius: 2,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],

                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (ctx) =>LoginScreen(widget.Uploadid)));
                      },
                      child: Container(
                        height: 100,
                        child: Center(child: Text('Upload',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),)),

                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.7),
                              spreadRadius: 6,
                              blurRadius: 2,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        setState(() {
                          BookLoading=true;
                        });
                        final BookUrl = await FirebaseFirestore.instance.collection('pdf').doc('bookaviewing').get();

                        print(BookUrl.data());
                        final file = await PDFApi.loadNetwork(BookUrl['pdf']);
                        print(file);
                        setState(() {
                          BookLoading=false;
                        });

                        if (file == null) return;
                        openPDF(context, file);
                      },
                      child: Container(
                        height: 100,
                        child: Center(child: Text('Book a Viewing',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),)),

                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.7),
                              spreadRadius: 6,
                              blurRadius: 2,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [

                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        setState(() {
                          OfferLoading=true;
                        });
                        final OfferUrl = await FirebaseFirestore.instance.collection('pdf').doc('multipleOffers').get();

                        print(OfferUrl.data());
                        final file = await PDFApi.loadNetwork(OfferUrl['pdf']);
                        print(file);
                        setState(() {
                          OfferLoading=false;
                        });

                        if (file == null) return;
                        openPDF(context, file);
                      },
                      child: Container(
                        height: 100,
                        child: Center(child: Text('Multiple Offers',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w600),)),

                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.7),
                              spreadRadius: 6,
                              blurRadius: 2,
                              offset: Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ) ,
        ),

    );
  }
}
