import 'package:flutter/material.dart';
import 'package:notischool/fragments/loading.dart';
import 'package:notischool/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Sign in to Notischool'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
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
              SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'notischool@example.com',
                    ),
                validator: (val) => val.isEmpty ? 'Enter an email' : null,    
                onChanged: (val){
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.blueGrey[400],
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                    if(_formKey.currentState.validate()){
                     setState(() => loading = true);
                    //dynamic because we are going to have something back
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result == null){
                        setState((){
                          error = 'Could not sign in with those credentials';
                          loading = false;
                          });
                    }
                  }
                },
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