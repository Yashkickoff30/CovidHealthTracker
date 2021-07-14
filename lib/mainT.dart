//import 'package:covid/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'delayed_animation.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'LoginT.dart';
import 'SignupT.dart';
import 'main.dart';
//import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:flutter_svg/flutter_svg.dart';
void mainT() => runApp(MyAppT());

class MyAppT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPageT(),
    );
  }
}

class FirstPageT extends StatefulWidget {
  @override
  _FirstPageTState createState() => _FirstPageTState();
}

class _FirstPageTState extends State<FirstPageT> {
  final FlutterTts flutterTts = FlutterTts();

  void initState(){
    flutterTts.setLanguage("ta-IN");
    flutterTts.setPitch(1);
    flutterTts.setSpeechRate(1.0);
    flutterTts.speak("வணக்கம், நான் Covid Health Tracker. நான் உங்கள் உடல்நிலையை கண்காணித்து , சமூக விலகலை பின்பற்ற உங்களுக்கு உதவுவேன்.");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Covid Health Tracker',
              style: TextStyle(fontSize: 20.0),
            ),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          body: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Stack(
              children: <Widget>[
                button(),
              ],
            ),color: Colors.blueGrey[700],
          ),
        ),
      ),
    );
  }
}

class button extends StatefulWidget {
  @override
  _buttonState createState() => _buttonState();
}

class _buttonState extends State<button> with SingleTickerProviderStateMixin {
  final int delayAmount = 500;
  @override
  void initState() {
     AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(

        children: <Widget>[
          AvatarGlow(
            endRadius: 90,
            duration: Duration(seconds: 2),
            glowColor: Colors.white,
            repeat: true,
            repeatPauseDuration: Duration(seconds: 2),
            startDelay: Duration(seconds: 1),
            child: Material(
              elevation: 8.0,

              shape: CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/logo.png'),
                  radius: 50.0,
                ),
                radius: 50.0,
              ),
            ),
          ),
          DelayedAnimation(
            child: Text("வரவேற்பு", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white),),
            delay: delayAmount + 1000,
          ),
          DelayedAnimation(
            child: Text("நான் கோவிட் ஹெல்த் டிராக்கர்", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),),
            delay: delayAmount + 2000,
          ),
          SizedBox(height: 80.0,),
          DelayedAnimation(
            child: Text("ஏற்கனவே ஒரு கணக்கு உள்ளதா??", style: TextStyle(
                fontSize: 19.0,
                color: Colors.white),),
            delay: delayAmount + 3000,
          ), SizedBox(height: 10.0,),
          DelayedAnimation(
            child: RaisedButton(
                child: Text(
                  'உள்நுழைய',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginT()));
                }),
            delay: delayAmount + 4000,
          ), SizedBox(height: 20.0,),
          DelayedAnimation(
            child: Text("புதிய கணக்கை துவங்கு", style: TextStyle(
                fontSize: 19.0,
                color: Colors.white),),
            delay: delayAmount + 5000,
          ), SizedBox(height: 10.0,),
          DelayedAnimation(
            child: RaisedButton(
                child: Text(
                  'பதிவுபெறுக',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupT()));
                }),
            delay: delayAmount + 6000,
          ),
          SizedBox(height: 20.0,),
          DelayedAnimation(
            child: Text("To change App language", style: TextStyle(
                fontSize: 19.0,
                color: Colors.white),),
            delay: delayAmount + 7000,
          ), SizedBox(height: 10.0,),
          DelayedAnimation(
            child: RaisedButton(
                child: Text(
                  'English',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()));
                }),
            delay: delayAmount + 8000,
          ),
        ],
      ),
    );
  }
}


/*
  Future<Album> createAlbum(double latitude,double longitude) async{

    final http.Response response = await http.post(
      'https://ceg-covid.herokuapp.com/latlong',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,double>{
        'lat': latitude,
        'long': longitude,
      }),
    );
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = jsonDecode(data); //"status": "Success"
      String postResult = decodedData['status'];

      if (postResult == "Success") {
        http.Response getResponse = await http.get('https://ceg-covid.herokuapp.com/latlong');
        print("status:${getResponse.statusCode}");
        if (getResponse.statusCode == 200) {
          var getData = getResponse.body;
          var getDecodedData = jsonDecode(getData);
          globales.distance = getDecodedData['value'];
          print("newvalue:${globales.distance}");
        }
      }
    }

    }*/



/*class Album {
  final double longitude;
  final double latitude;


  Album({this.longitude, this.latitude});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      latitude: json['latitude'],
      longitude: json['longitude'],

    );
  }
}
*/