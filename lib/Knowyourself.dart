import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend1db/Cough.dart';
import 'package:frontend1db/Sneeze.dart';
//import 'dart:math';
import 'Dashboard.dart';
import 'Temperature.dart';
import 'Sneeze.dart';
import 'Cough.dart';
import 'Record.dart';

class Knowyourself extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: AppBar(
        title: Text("Know Yourself"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body:Stack(
        children: <Widget>[
          // background(),
          Container(padding:EdgeInsets.only(top:150.0,left: 90.0),child: SvgPicture.asset('assets/health.svg',height: 150.0,)),
          Yourdetails(),
        ],
      ),
    );
  }
}

class Yourdetails extends StatefulWidget {
  @override
  _YourdetailsState createState() => _YourdetailsState();
}

class _YourdetailsState extends State<Yourdetails> {
  final _auth = FirebaseAuth.instance;
  //final _fs = Firestore.instance;
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

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
              margin: EdgeInsets.only(top:20.0,bottom: 70.0,right:0.0),

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                border: Border.all(width: 1.0,color: Colors.black87),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                 // bottomRight: Radius.circular(20.0),
                ),
              ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 0.0),
                   child: Center(child: Text("SAFER LIMIT\n",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),)),
                ),
                Container(
                  padding: EdgeInsets.only(right:130.0),
                   child: Container(padding:EdgeInsets.only(left: 1.0),child: Text("* TEMPERATURE: <98.0",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
                ),
                Container(
                    padding: EdgeInsets.only(right:150.0),
                    child: Container(padding:EdgeInsets.only(left: 1.0),child: Text("* COUGH: <50.0/DAY",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
                ),
                Container(
                    padding: EdgeInsets.only(right:145.0),
                    child: Container(padding:EdgeInsets.only(left: 1.0),child: Text("* SNEEZE: <30.0/DAY",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 70.0,right: 200.0),
            child:  Text('CHECK YOURS:', style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.lightBlue[600],),),
          ),


          Container(
            //padding: EdgeInsets.all(20.0),
            padding: EdgeInsets.only(bottom: 20.0),
            margin: EdgeInsets.only(top:10.0,bottom: 40.0,right:10.0,left:10.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              border: Border.all(width: 1.0,color: Colors.black87),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
               // bottomRight: Radius.circular(20.0),
              ),
            ),
         child:  Column(
             children: <Widget>[

               IconButton(icon: Icon(Icons.ac_unit), onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>Temperature()));}),
               Container(
                  //  padding: EdgeInsets.only(left: 0.0),
                    child: Center(child: Text( "TEMPERATURE DETAILS",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)),
               ),
             ],
         ),
         ),


          Container(
            //padding: EdgeInsets.all(20.0),
            padding: EdgeInsets.only(bottom: 20.0),
            margin: EdgeInsets.only(top:0.0,bottom: 40.0,right:10.0,left:10.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              border: Border.all(width: 1.0,color: Colors.black87),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                // bottomRight: Radius.circular(20.0),
              ),
            ),
            child:  Column(
              children: <Widget>[

                IconButton(icon: Icon(Icons.security), onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>Cough()));}),
                Container(
                  //  padding: EdgeInsets.only(left: 0.0),
                  child: Center(child: Text( "COUGH DETAILS",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)),
                ),
              ],
            ),
          ),

          Container(
            //padding: EdgeInsets.all(20.0),
            padding: EdgeInsets.only(bottom: 20.0),
            margin: EdgeInsets.only(top:0.0,bottom: 40.0,right:10.0,left:10.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              border: Border.all(width: 1.0,color: Colors.black87),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                // bottomRight: Radius.circular(20.0),
              ),
            ),
            child:  Column(
              children: <Widget>[

                IconButton(icon: Icon(Icons.local_hospital), onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>Sneeze()));}),
                Container(
                  //  padding: EdgeInsets.only(left: 0.0),
                  child: Center(child: Text( "SNEEZE DETAILS",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)),
                ),
              ],
            ),
          ),


          RaisedButton(
            child: Text(
              'Record My Audio',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                // bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Record()));
            },
          ),

          RaisedButton(
            child: Text(
              'Detailed Report',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                // bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),

        ]
      ),
    );

  }
}

