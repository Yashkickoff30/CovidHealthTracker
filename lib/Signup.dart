import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:frontend1db/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
//import 'package:intl/intl.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FullScreenPage(),
    );
  }
}

class FullScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SIGN UP',
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(

        child: Stack(
          children: <Widget>[

            Center(child: SvgPicture.asset('assets/bg3.svg',width: 250.0,height: 400.0,)),
            Home(),
          ],
        ),color: Colors.blueGrey[700],
      ),
    );
  }
}

String now = DateTime.now().toString();
String todaydate = now.substring(0,10);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String error;
  String info;
  final _fs = Firestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            ///crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                //padding: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                margin: EdgeInsets.only(top:150.0,bottom: 90.0,right:80.0),

                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    border: Border.all(width: 1.0,color: Colors.black87),
                    borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Container(
                  child: TextFormField(
                    onChanged: (val) {
                      email = val;
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.alternate_email, color: Colors.black, size: 40.0),
                        hintText: 'EmailId',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'Enter your mail id',
                        labelStyle: TextStyle(color: Colors.black)),
                    validator:(email){
                      Pattern pattern =
                          r'^([a-z0-9_\-\.]+)@([a-z.]+)\.([a-z]{2,5})$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(email))
                        return 'Invalid username';
                      else
                        return null;
                    },
                  ),
                ),
              ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
            margin: EdgeInsets.only(top:10.0,bottom: 65.0,left:80.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              border: Border.all(width: 1.0,color: Colors.black),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              )
          ),
              child:Container(
                child: TextFormField(
                  onChanged: (val) {
                    password = val;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.work,
                        color: Colors.black,
                        size: 40.0,
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'Enter Your Password',
                      labelStyle: TextStyle(color: Colors.black)),
                  validator:(password){
                    Pattern pattern =
                        r'^[ A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(password)   )
                      return 'Invalid password/\npassword is less than 6\ncharacter';
                    else
                      return null;
                  },
                ),
              ),
            ),
              Container(
                padding: EdgeInsets.only(left: 20.0, top: 50.0),
                child: RaisedButton(
                  onPressed: () async {
                    dynamic newUser;
                    if(_formKey.currentState.validate()) {
                      try {
                        newUser = await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                      }
                      catch (e) {
                        print(e);
                        newUser=null;
                        String i=e.toString();
                        final startindex = i.indexOf('(');
                        final finalindex = i.indexOf(',');
                        info = i.substring(startindex,finalindex);
                      }

                        if (newUser != null) {
                          _fs.collection('info').document('$email').collection('Activities').document('Activity 1').setData({
                            'count':'0',
                            'red':'0',
                            'date':todaydate,
                            'colour':'green',
                            'cough':0
                          });
                           showDialog(
                              context: context,
                              builder: (BuildContext context) {
      // return object of type Dialog
                                return AlertDialog(
                                   title: new Text("Message"),
                                   content: new Text("Successfully Registered"),
                                   actions: <Widget>[
      // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                   child: new Text("Ok"),
                                    onPressed: () {
                                     Navigator.of(context).pop();
                                     },),
                                   ],);
                                },);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }

                        else if(info == "(ERROR_NETWORK_REQUEST_FAILED")
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("Message"),
                                content: new Text("Poor Network Connection"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();},),
                                ],);},);

                        }

                        else if(info == "(ERROR_EMAIL_ALREADY_IN_USE")
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("Message"),
                                content: new Text("Email Already in Use"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();},),
                                ],);},);

                        }


                        else
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("Message"),
                                  content: new Text("Invalid Credential/password should be greater than 6 character"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("Ok"),
                                      onPressed: () {
                                        Navigator.of(context).pop();},),
                                  ],);},);
                          }

                    }
                  },
                  child: Text('Sign In',style: TextStyle(fontSize: 20.0,),),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
