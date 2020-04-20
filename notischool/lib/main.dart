import 'package:flutter/material.dart';
import 'package:notischool/screens/wrapper.dart';
import 'package:notischool/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:notischool/models/user.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        ),
    );
  }
}