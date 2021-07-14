import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend1db/Temperature.dart';
import 'package:frontend1db/TemperatureT.dart';
//import 'dart:math';
import 'DashboardT.dart';
import 'SneezeT.dart';
import 'CoughT.dart';
import 'RecordT.dart';

class KnowyourselfT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: AppBar(
        title: Text("உங்களை அறிந்து கொள்ளுங்கள்",style: TextStyle(fontSize: 15.0),),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      body:Stack(
        children: <Widget>[
          // background(),
          Container(padding:EdgeInsets.only(top:170.0,left: 50.0),child: SvgPicture.asset('assets/health.svg',height: 150.0,)),
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
                    child: Center(child: Text("பாதுகாப்பான வரம்பு\n",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),)),
                  ),
                  Container(
                      padding: EdgeInsets.only(right:90.0),
                      child: Container(padding:EdgeInsets.only(left: 1.0),child: Text("* உடல் வெப்பநிலை: <98.0",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
                  ),
                  Container(
                      padding: EdgeInsets.only(right:135.0),
                      child: Container(padding:EdgeInsets.only(left: 1.0),child: Text("* இருமல்: <50.0/நாள்",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
                  ),
                  Container(
                      padding: EdgeInsets.only(right:140.0),
                      child: Container(padding:EdgeInsets.only(left: 1.0),child: Text("* தும்மல்: <30.0/நாள்",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),))
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(top: 70.0,right: 90.0),
              child:  Text('உங்கள் விவரங்கள்:', style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.lightBlue[600],),),
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

                  IconButton(icon: Icon(Icons.ac_unit), onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>TemperatureT()));}),
                  Container(
                    //  padding: EdgeInsets.only(left: 0.0),
                    child: Center(child: Text( "வெப்பநிலை விவரங்கள்",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)),
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

                  IconButton(icon: Icon(Icons.security), onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>CoughT()));}),
                  Container(
                    //  padding: EdgeInsets.only(left: 0.0),
                    child: Center(child: Text( "இருமல் விவரங்கள்",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)),
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

                  IconButton(icon: Icon(Icons.local_hospital), onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>SneezeT()));}),
                  Container(
                    //  padding: EdgeInsets.only(left: 0.0),
                    child: Center(child: Text( "தும்மல் விவரங்கள்",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)),
                  ),
                ],
              ),
            ),


            RaisedButton(
              child: Text(
                'ஆடியோவை பதிவுசெய்',
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
                    context, MaterialPageRoute(builder: (context) => RecordT()));
              },
            ),

          ]
      ),
    );

  }
}

