import 'package:flutter/material.dart';
import 'package:notischool/models/notices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';


class ClassNotices extends StatefulWidget {
  final int classIndex;
  final String uid;
  ClassNotices({this.classIndex,this.uid});
  @override
  _ClassNoticesState createState(){

    return _ClassNoticesState(); 
    }
}


class _ClassNoticesState extends State<ClassNotices> {
  Color iconColor = Colors.black;
  // In function of the user, set that value to true or false
  final databaseReference = Firestore.instance;
  List listsubscribes = [false,false,false,false,false,false];

  @override

  void initState() {
  Firestore.instance
      .collection('users')
      .document(widget.uid)
      .get()
      .then((DocumentSnapshot ds) {
        setState(() {
        listsubscribes = ds.data["subscribes"];});
      });
  }
  @override
    Widget build(BuildContext context) {
      FloatingActionButton subscribeButton = new FloatingActionButton(
        onPressed: () {
          FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
          _firebaseMessaging.getToken().then((token) {
            DatabaseReference databaseReference = new FirebaseDatabase().reference();
            if (listsubscribes[widget.classIndex] == false){
              setState(() {
              listsubscribes[widget.classIndex] =true;
              databaseReference.child('fcm-token' + (widget.classIndex+1).toString() + '/${token}').set({"token": token});
              print("You subscribed");
            });} else{
              setState(() {
              listsubscribes[widget.classIndex] =false;
              databaseReference.child('fcm-token' + (widget.classIndex+1).toString() + '/${token}').set({"token": null});
              print("You unsubscribed");
            });}
            Firestore.instance
              .collection('users')
              .document(widget.uid)
              .updateData({
                "subscribes":listsubscribes
              });
          });
        },
        child: listsubscribes[widget.classIndex]? Icon(Icons.check, color:Colors.white):Icon(Icons.add_alert, color:Colors.black),
        backgroundColor: listsubscribes[widget.classIndex]? Colors.lightGreen : Colors.lightBlue,
      );
    return Scaffold( //return loading widget instead if loading state change
      body: _buildBody(context),
      floatingActionButton: subscribeButton,
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('classes').document(widget.classIndex.toString()).collection('notices').orderBy('date',descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildListNotices(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildListNotices(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final notice = Notice(data);

    return Padding(
      key: ValueKey(notice.id),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: Text(notice.formatedDate),
          title: Text(notice.object , style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          subtitle:Text(notice.text, style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20),),
          onTap: () => print(notice.toString()),
        ),
      ),
    );
  }
}