import 'package:flutter/material.dart';
import 'package:frontend1db/Dashboard.dart';
//import 'package:frontend1db/auth.dart';
import 'Record.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Dashboard.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Cough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FullScreenPage(),
    );
  }
}

class FullScreenPage extends StatefulWidget {
  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {

  final _auth = FirebaseAuth.instance;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cough Details',
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      // resizeToAvoidBottomPadding: false,
      body: Container(
        //padding: EdgeInsets.only(bottom: 80.0),
        color: Colors.blueGrey[700],
        child: Stack(
          children: <Widget>[
//SizedBox(width: 200.0,),
            Container(padding:EdgeInsets.only(top:200.0,left: 60.0),child: SvgPicture.asset('assets/bg5.svg',height: 200.0,)),
            Details(),
          ],
        ),
      ),
        bottomNavigationBar:CurvedNavigationBar(
            color: Colors.black,
            backgroundColor: Colors.blueGrey[700],
            buttonBackgroundColor: Colors.black,
            height: 70,
            index: 2,
            items: <Widget>[

              Icon(Icons.mic,size: 20, color: Colors.white),
              Icon(Icons.dashboard, size: 20, color: Colors.white),
              Icon(Icons.today, size: 20, color: Colors.white),
            ],
            animationDuration: Duration(
                milliseconds: 313
            ),
            onTap: (index){
              if(index == 0){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Record()));
              }
              if(index == 1){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dashboard()));
              }
            }
        )
    );
  }
}

class Details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //calculate

    return
      Column(
        children: <Widget>[
          SizedBox(height: 70.0,),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  border: Border.all(width: 1.0, color: Colors.black),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    //bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(40.0),
                  )
              ),
              padding: EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 50.0),
              child: Text(
                "cough 10 time :\n29 April 2020 at 12:30:31 UTC+5:30 2 times :\n26 April 2020 at 11:12:32 UTC+5:30 3 times :\n25 April 2020 at 09:05:45 UTC+5:30 4 times :\n24 April 2020 at 02:06:30 UTC+5:30 5 times :\n28 April 2020 at 12:12:20 UTC+5:30 6 times :\n27 April 2020 at 07:08:50 UTC+5:30 7 times :\n30 April 2020 at 03:04:20 UTC+5:30",

                style: TextStyle(color: Colors.red[900], fontSize: 20.0),),
            ),
          ),
        ],
      );
  }

}