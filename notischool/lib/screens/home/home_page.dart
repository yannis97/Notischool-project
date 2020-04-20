import 'package:flutter/material.dart';
import 'package:notischool/fragments/class_notices.dart';
import 'package:notischool/screens/addNotice/addNotice.dart';
import 'package:notischool/services/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final bool adminMode;
  final String uid;
  HomePage({this.adminMode,this.uid});
  final drawerItems = [
    new DrawerItem("1ère", Icons.accessibility_new),
    new DrawerItem("2ème", Icons.accessibility_new),
    new DrawerItem("3ème", Icons.accessibility_new),
    new DrawerItem("4ème", Icons.accessibility_new),
    new DrawerItem("5ème", Icons.accessibility_new),
    new DrawerItem("6ème", Icons.accessibility_new),
  ];
  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  String titleMenu = "NotiSchool 1ère";
  final AuthService _auth = AuthService();

  
  _getDrawerItemWidget(int classIndex) {

    return new ClassNotices(classIndex : classIndex ,uid:widget.uid);
  }
  
  _onSelectItem(int index) {
    setState((){
       _selectedDrawerIndex = index;
       titleMenu = "NotiSchool"+' '+widget.drawerItems[_selectedDrawerIndex].title;
       notifications[index] = 0;
       });
    Navigator.of(context).pop(); // close the drawer
    Firestore.instance
      .collection('users')
      .document(widget.uid)
      .updateData({
        "NumNotifClass": notifications
    });
  }
  //To avoid onMessage call to be triggered twice
  static int i = 0;
  List notifications = [0, 0, 0, 0, 0, 0];

  
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  @override
  void initState() {
    Firestore.instance
            .collection('users')
            .document(widget.uid)
            .get()
            .then((DocumentSnapshot ds) {
              setState(() {
                notifications = ds.data["NumNotifClass"];
              });
            });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if(i%2==0) {

          String classnumber = message["notification"]["body"];
          int number = int.parse(classnumber[classnumber.length-1]);
          print('onMessage called: $message');
          Firestore.instance
          .collection('users')
          .document(widget.uid)
          .get()
          .then((DocumentSnapshot ds) {
            setState(() {
                  notifications[number-1] += 1;
                });
            Firestore.instance
              .collection('users')
              .document(widget.uid)
              .updateData({
                "NumNotifClass": notifications
            });
          });
        }
        i++;
     },
     onResume: (Map<String, dynamic> message) async {
        print('onResume called: $message');       
     },
     onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch called: $message');    
     },
    );
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
     FloatingActionButton adminAddOption = new FloatingActionButton(
       heroTag: "addNoticeBtn",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNoticePage()));
        },
        child: Icon(Icons.add),
      );
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: notifications[i] == 0 ? new Icon(d.icon):
          new Stack(
                  children: <Widget>[
                    new Icon(d.icon),
                    new Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: new Text(
                          notifications[i].toString(),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.exit_to_app),
            label: Text('Logout'),
            onPressed:() async {
              await _auth.signOut();
            }
          )
        ],
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(titleMenu),
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
            child: Text(
              'Select class',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/cover.jpg'))),
          ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      floatingActionButton: widget.adminMode == true ? adminAddOption : null,
    );
  }
}