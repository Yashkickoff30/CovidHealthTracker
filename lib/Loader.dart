/*import 'package:flutter/cupertino.dart';
import 'package:frontend1db/Dashboard.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'Dashboard.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  void initState() {
    int count = 0;
    super.initState();
    //_getCurrentLocation();
    Future.delayed(Duration(seconds: 5),(){print("hi");
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) => Dashboard()
    )
    );
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
        'Covid Health Tracker',
        style: TextStyle(fontSize: 20.0),
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
    ),
      body: Stack(
        //fit: StackFit.expand,
        children: <Widget>[
      Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    ),

    SizedBox(height: 100.0,),
    Container(
    child: Column(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage('assets/load.gif'),
          radius: 100.0,
        ),Text("Please wait, data is processing"),
        CircularProgressIndicator(),

      ]
    ),
    ),
     ],
    ),
    );
  }
}*/
