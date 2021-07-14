import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Questions.dart';
import 'globals.dart' as globales;

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration form"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: Stack(
            children: <Widget>[
              Container(padding:EdgeInsets.only(top:200.0,left: 60.0),child: SvgPicture.asset('assets/bg5.svg',height: 200.0,)),
             // background(),
              Formdetails(),
            ],
          ),color: Colors.blueGrey[700],
        ),
    );
  }
}


class Formdetails extends StatefulWidget {
  @override
  _FormdetailsState createState() => _FormdetailsState();
}

class _FormdetailsState extends State<Formdetails> {
  final _fs = Firestore.instance;
  FirebaseUser fbuser;
  String userName;

  @override
  void initState() {
    super.initState();
     getUser();
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        fbuser = user;
        userName = fbuser.email;

      }
    } catch (e) {
      print(e);
    }
  }


  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  //padding: EdgeInsets.all(20.0),
                  padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                  margin: EdgeInsets.only(top:50.0,bottom: 65.0,right:80.0),

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
                        globales.name = val;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.person, color: Colors.black, size: 30.0),
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.black),
                          labelText: 'Enter your name',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator:(name){
                        Pattern pattern =
                            r'^[ A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(name))
                          return 'Invalid username';
                        else
                          return null;

                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                  margin: EdgeInsets.only(top:0.0,bottom: 65.0,left:80.0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      border: Border.all(width: 1.0,color: Colors.black),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )
                  ),
                  child: Container(
                    child: TextFormField(
                      onChanged: (val) {
                        globales.phoneNo = val;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.phone, color: Colors.black, size: 30.0),
                          hintText: 'Phone',
                          hintStyle: TextStyle(color: Colors.black),
                          labelText: 'Enter your phoneno',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator:(phoneNo){
                        Pattern pattern =
                            r'^[ 0-9]+(?:[ _-][0-9]+)*$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(phoneNo))
                          return 'Invalid phonenumber';
                        else
                          return null;

                      },
                    ),
                  ),
                ),
          Container(
            //padding: EdgeInsets.all(20.0),
              padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
              margin: EdgeInsets.only(top:0.0,bottom: 65.0,right:80.0),

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
                        globales.age = val;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.ac_unit, color: Colors.black, size: 30.0),
                          hintText: 'Age',
                          hintStyle: TextStyle(color: Colors.black),
                          labelText: 'Enter your age',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator:(age){
                        Pattern pattern =
                            r'^[ 0-9]+(?:[0-9]+)*$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(age))
                          return 'Invalid age';
                        else
                          return null;

                      },
                    ),
                  ),
                ),
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                  margin: EdgeInsets.only(top:0.0,bottom: 65.0,left:80.0),
                  decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  border: Border.all(width: 1.0,color: Colors.black),
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
        )
        ),
                  child: Container(
                    child: TextFormField(
                      onChanged: (val) {
                        globales.occupation = val;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.work, color: Colors.black, size: 30.0,
                          ),
                          hintText: 'Occupation',
                          hintStyle: TextStyle(color: Colors.black),
                          labelText: 'Your Profession',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator:(occupation){
                        Pattern pattern =
                            r'^[ A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(occupation))
                          return 'Invalid Occupation';
                        else
                          return null;

                      },
                    ),
                  ),
                ),

                Container(
                  //padding: EdgeInsets.all(20.0),
                  padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                  margin: EdgeInsets.only(top:0.0,bottom: 65.0,right:80.0),

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
                        globales.pincode = val;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.work, color: Colors.black, size: 30.0,
                          ),
                          hintText: 'Pincode',
                          hintStyle: TextStyle(color: Colors.black),
                          labelText: 'Your Pincode',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator:(pincode){
                        Pattern pattern =
                            r'^[ 0-9]+(?:[ _-][0-9]+)*$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(pincode))
                          return 'Invalid Pincode';
                        else
                          return null;

                      },
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                  margin: EdgeInsets.only(top:0.0,bottom: 65.0,left:80.0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      border: Border.all(width: 1.0,color: Colors.black),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )
                  ),
                  child: Container(
                    child: TextFormField(
                      onChanged: (val) {
                        globales.sex = val;
                      },
                      decoration: const InputDecoration(
                          icon: Icon(Icons.work, color: Colors.black, size: 30.0,
                          ),
                          hintText: 'SEX',
                          hintStyle: TextStyle(color: Colors.black),
                          labelText: 'Your SEX',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator:(sex){
                        Pattern pattern =
                            r'^[ A-Za-z]+(?:[ _-][A-Za-z]+)*$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(sex))
                          return 'Reenter your sex';
                        else
                          return null;

                      },
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 130.0, top: 20.0),
                  child: RaisedButton(
                    onPressed: () {
                     // globales.count=1;
                      if(_formKey.currentState.validate()) {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => Questions()));
                      }
                      //database
                      _fs.collection('info').document('$userName').collection('Activities').document('Activity 1').updateData({
                        //'email': userName,
                        'name': globales.name,
                        'phone': globales.phoneNo,
                        'age': globales.age,
                        'occupation': globales.occupation,
                        'pincode': globales.pincode,
                        'sex': globales.sex,
                        'count':'1',
                      });
                    },
                    child: Text(
                      'submit',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}