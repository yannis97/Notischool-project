import 'package:flutter/material.dart';
import 'package:notischool/models/user.dart';
import 'package:notischool/screens/authenticate/authenticate.dart';
import 'package:notischool/screens/home/home_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  bool adminMode = false;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    //return either Home or Authenticate widget
    if(user == null){
      return Authenticate();
    }else{
      if(user.uid == "rroYbIadk2bXs9wr3K92os4GDkj1"){
        adminMode = true;
        //return HomePage();
      }else{adminMode = false;}
      return HomePage(adminMode:adminMode , uid : user.uid);
    }
  }
}