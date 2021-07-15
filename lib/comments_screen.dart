import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatelessWidget {
  final String id;
  CommentsScreen(this.id);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('houseId', isEqualTo: id)
              .snapshots(),
          builder: (context, snapeshot) {
            if (snapeshot.hasData) {
              if(snapeshot.data!.docs.length==0){
                return Center(child: Text('No Comment found'),);
              }
              return ListView.builder(
                itemCount: snapeshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Comment',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapeshot.data!.docs[index]['name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                              Text(snapeshot.data!.docs[index]['rating'].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.yellow),),
                            ],
                          ),
                          Text(snapeshot.data!.docs[index]['comment'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.cyan),)
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.cyan),

              ));
            }
          },
        ),
      ),
    ));
  }
}
