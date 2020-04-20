import 'package:flutter/material.dart';
import 'package:notischool/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //text field state
  String email = '';
  String password = '';
  String secPassword = '0';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Sign up to Notischool'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () {
              widget.toggleView();
            }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0) ,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'notischool@example.com',
                    ),
                onChanged: (val){
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val){
                  setState(() => password = val);
                }               
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                      labelText: 'Confirm password',
                    ),
                obscureText: true,
                validator: (val) {
                      if (val != password) {
                        return 'Please enter same password as beyond';
                      }
                      return null;
                    },
                onChanged: (val){
                  setState(() => secPassword= val);
                }               
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.blueGrey[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    //dynamic because we are going to have something back
                      dynamic result = await _auth.registerWithEmailAndPassword(email,password);
                      if(result == null){
                        setState(() => error = 'Please supply valid email');
                      } else{
                          var user = {
                          'email': email,
                          'subscribes': [false,false,false,false,false,false],
                          'NumNotifClass':[0,0,0,0,0,0],
                          };
                          Firestore.instance
                                .collection('users')
                                .document(result.uid)
                                .setData(user);                                                 
                        }
                  }
                }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0)
                ),
            ],
          ),
        ),
      ),
    );
  }
}