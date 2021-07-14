//import 'package:covid/login.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:background_location/background_location.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:frontend1db/DashboardT.dart';
import 'package:frontend1db/Questions.dart';
import 'package:frontend1db/delayed_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:background_location/background_location.dart';
import 'globals.dart'as globales;
import 'Dashboard.dart';
import 'DashboardT.dart';
import 'Login.dart';
import 'Signup.dart';
import 'Questions.dart';
import 'QuestionsT.dart';
//import 'package:intl/intl.dart';
import 'mainT.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:// Column(
      //children: <Widget>[
      Splashscreen(),
      // FirstPage(),
      // ],
      // ),
    );
  }
}
String distance;
String username;
String lang;
String date;
bool newuser;
String now = DateTime.now().toString();
String todaydate = now.substring(0,10);


//SPLASH SCREEN PAGE

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  //String todaydate = DateFormat('yMd').format(DateTime.now());
  int count = 0;
  String latitude = "waiting...";
  String longitude = "waiting...";
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";
  @override
  void initState() {
     count = 0;
    super.initState();


     Future.delayed(Duration(seconds: 5),(){print("hi");
     check_if_already_login();
     },
     );
  }

  void check_if_already_login() async {
    SharedPreferences logindata =await SharedPreferences.getInstance();
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == true) {
      globales.i = 1;
      print("hiii");
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => FirstPage()));
    }
    if (newuser == false) {
      globales.i = 0;
      lang = logindata.getString('lang');
      print(logindata.getString('username'));
      username = logindata.getString('username');
      print(logindata.getString('date'));
      date = logindata.getString('date');

      if (lang == 'english') {
        print("today:$todaydate");
        print("seven:$date");
        if (date == todaydate) {
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(builder: (context) => Questions()));
        }
        else {
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => Loader()));
        }
      }
      else {
        print("today:$todaydate");
        print("seven:$date");
        if (todaydate == date) {

          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(builder: (context) => QuestionsT()));
        }
        else {
          Navigator.pushReplacement(
              context, new MaterialPageRoute(builder: (context) => LoaderT()));
        }
      }
    }
  }


  /* Future<void> initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: onSelectNotification);
  }

 void _showNotifications()async{
    print("hi");
    await notification();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'Channel_ID', 'channel title', 'Channel body',
      priority: Priority.High,
      importance: Importance.Max,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello everyone', 'please maintain social distance',
        notificationDetails);
  }

  Future onSelectNotification(String payload) {
    if (payload != null) {
      print(payload);
    }
    //to
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            print("");
          },
          child: Text('okay'),)
      ],
    );
  }*/





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
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100.0,),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/giphy.gif'),
                      radius: 200.0,
                    )
                  ] ,
                ),
              ),

              Column(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding:EdgeInsets.only(top:20.0),
                  ),
                  Text("Follow Social Distancing",style: TextStyle(color: Colors.white,fontSize: 18.0,fontWeight:FontWeight.bold),)
                ],
              ),
            ],
          )
        ],
      ),

    );
  }
}

// MAIN PAGE

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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
          body: Container(color: Colors.blueGrey[700],
            child: Stack(
              children: <Widget>[
                button(),
              ],
            ),
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
    return  Center(
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
                backgroundImage: AssetImage('assets/logo.png'),
                radius: 50.0,
              ),
            ),
          ),
          DelayedAnimation(
            child: Text("Welcome", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white),),
            delay: delayAmount + 1000,
          ),
          DelayedAnimation(
            child: Text("I'm Covid Health Tracker", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white),),
            delay: delayAmount + 2000,
          ),
          SizedBox(height: 80.0,),
          DelayedAnimation(
            child: Text("Already have an account??", style: TextStyle(
                fontSize: 20.0,
                color: Colors.white),),
            delay: delayAmount + 3000,
          ), SizedBox(height: 10.0,),
          DelayedAnimation(
            child: RaisedButton(
                child: Text(
                  'Login',
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
                      MaterialPageRoute(builder: (context) => Login()));
                }),
            delay: delayAmount + 4000,
          ), SizedBox(height: 20.0,),
          DelayedAnimation(
            child: Text("Create a new account", style: TextStyle(
                fontSize: 20.0,
                color: Colors.white),),
            delay: delayAmount + 5000,
          ), SizedBox(height: 10.0,),
          DelayedAnimation(
            child: RaisedButton(
                child: Text(
                  'Sign up',
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
                      MaterialPageRoute(builder: (context) => Signup()));
                }),
            delay: delayAmount + 6000,
          ),
          SizedBox(height: 20.0,),
          DelayedAnimation(
            child: Text("பயன்பாட்டு மொழியை மாற்ற:", style: TextStyle(
                fontSize: 20.0,
                color: Colors.white),),
            delay: delayAmount + 7000,
          ), SizedBox(height: 10.0,),
          DelayedAnimation(
            child: RaisedButton(
                child: Text(
                  'தமிழ்',
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
                      MaterialPageRoute(builder: (context) => MyAppT()));
                }),
            delay: delayAmount + 8000,
          ),
        ],
      ),
    );
  }
}

