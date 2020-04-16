import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/roundedbtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "reg_Screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  String name;
  String email;
  String password;
  String error = '';
  bool showSpinner = false;

  String confirm_password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 180.0,
                    child: Image.asset('images/simplechat.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red[100],
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter Your Name'),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Email Address'),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password'),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  confirm_password = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Confirm Password'),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                btncolor: Colors.redAccent[100],
                title: 'register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if(password==confirm_password){
                  try {
                    print('here');
                    final newUser = await auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      print('here again');
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    firestore.collection('Name').add({
                      'name': name,
                      'email':email,
                    });
                  } catch (e) {
                    print(e);
                  }
                  }
                  else{
                    setState(() {
                      error='Passwords dont Match';
                    });
                  }
                  setState(() {
                   showSpinner=false;
                  });

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
