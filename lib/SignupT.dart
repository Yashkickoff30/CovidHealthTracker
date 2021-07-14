import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loginT.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
import 'mainT.dart';

class SignupT extends StatelessWidget {
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
        title: Row(
          children: <Widget>[
            IconButton(padding:EdgeInsets.only(right: 80.0),onPressed:(){ Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppT()));}, icon:Icon(Icons.arrow_back),),
            Text(
              'பதிவுசெய்க',
            ),],
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.blueGrey[700],
        child: Stack(
          children: <Widget>[

            Center(child: SvgPicture.asset('assets/bg3.svg',width: 250.0,height: 400.0,)),
            Home(),
          ],
        ),
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
                margin: EdgeInsets.only(top:170.0,bottom: 90.0,right:80.0),

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
                        hintText: 'அஞ்சல் ஐடி',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'உங்கள் அஞ்சல் ஐடி',
                        labelStyle: TextStyle(color: Colors.black)),
                    validator:(email){
                      Pattern pattern =
                          r'^([a-z0-9_\-\.]+)@([a-z.]+)\.([a-z]{2,5})$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(email))
                        return 'தவறான அஞ்சல் ஐடி';
                      else
                        return null;
                    },
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                margin: EdgeInsets.only(top:0.0,bottom: 80.0,left:45.0),
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
                      password = val;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                        icon: Icon(
                          Icons.work,
                          color: Colors.black,
                          size: 40.0,
                        ),
                        hintText: 'கடவுச்சொல்',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'கடவுச்சொல் உள்ளிடவும்',
                        labelStyle: TextStyle(color: Colors.black)),
                    validator:(password){
                      if (password.length<6)
                        return 'தவறான கடவுச்சொல் \nகடவுச்சொல் 6\nஎழுத்துகளுக்கு\nகுறைவாக உள்ளது';
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
                              title: new Text("செய்தி"),
                              content: new Text("வெற்றிகரமாக பதிவு செய்யப்பட்டது"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("சரி"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },),
                              ],);
                          },);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginT()));
                      }

                      else if(info == "(ERROR_NETWORK_REQUEST_FAILED")
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("செய்தி"),
                                  content: new Text("மோசமான இணைய இணைப்பு"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("சரி"),
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
                              title: new Text("செய்தி"),
                              content: new Text("மின்னஞ்சல் \nஏற்கனவே உபயோகத்தில் உள்ளது"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("சரி"),
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
                              title: new Text("செய்தி"),
                              content: new Text("தவறான தரவு\n /கடவுச்சொல் 6 எழுத்துகளுக்கு மேல் இருக்க வேண்டும்"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                  child: new Text("சரி"),
                                  onPressed: () {
                                    Navigator.of(context).pop();},),
                              ],);},);
                      }

                    }
                  },
                  child: Text('உள்நுழைக',style: TextStyle(fontSize: 20.0,),),
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
