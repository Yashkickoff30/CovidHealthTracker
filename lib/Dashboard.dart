import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_location/background_location.dart';
import 'globals.dart'as globales;
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'Record.dart';
//import 'package:frontend1db/Cough.dart';

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
AndroidInitializationSettings androidInitializationSettings;
IOSInitializationSettings iosInitializationSettings;
InitializationSettings initializationSettings;

final _auth = FirebaseAuth.instance;
final _fs = Firestore.instance;
FirebaseUser fbuser;
String userName;
String ans1;
String ans2;
String ans3;
String ans4;
String ans5;
String social = '1';
String color;
int analysis1 =0;
int analysis2 =0;
int analysis3 =0;
int counts ;
String q1='';
String q2='';
String q3='';
String q4='';
String q5='';
String q6='';
String q7='';
String q8='';
String info;
String date;
int cough;


class _LoaderState extends State<Loader> {
  String latitude = "waiting...";
  String longitude = "waiting...";
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";
  String distance;
  String DBdate;
  int bgcount = 0;
  @override
  void initState() {
     counts = 0;
     analysis1 =0;
     bgcount =0;
     analysis2 =0;
    super.initState();
    initializing();
    getUser();
    if(globales.i == 0) {
      BackgroundLocation.startLocationService();
      BackgroundLocation.getLocationUpdates((location) {
        if(bgcount == 10){
        setState(() {
          this.latitude = location.latitude.toString();
          this.longitude = location.longitude.toString();
          this.accuracy = location.accuracy.toString();
          this.altitude = location.altitude.toString();
          this.bearing = location.bearing.toString();
          this.speed = location.speed.toString();
        });
        //
        print("vanalam");
        createAlbum(double.parse(latitude), double.parse(longitude));
        //_showNotifications();
        bgcount = 0;
        print("""\n
      Latitude:  $latitude
      Longitude: $longitude
      Altitude: $altitude
      Accuracy: $accuracy
      Bearing:  $bearing
      Speed1: $speed
      date: $date
      
      """);
        }
        bgcount = bgcount +1;
        print("!@#$bgcount");
      });
    }
    Future.delayed(Duration(seconds: 5),(){print("hi");
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Dashboard()
    )
    );
    },
    );
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        SharedPreferences logindata =await SharedPreferences.getInstance();
        fbuser = user;
        userName = fbuser.email;
        print("User:$userName");
        date=logindata.getString('date');
        print(date);
        DB_details();
      }
      else{
        SharedPreferences logindata =await SharedPreferences.getInstance();
        logindata = await SharedPreferences.getInstance();
        userName=logindata.getString('username');
        date=logindata.getString('date');
        print(userName);
        DB_details();
      }
    } catch (e) {
      print(e);
    }
  }
void DB_details(){
  _fs.collection('info').document('$userName').collection('Activities').getDocuments().then((QuerySnapshot snapshot){
    ans1=snapshot.documents[1]['Do you have Cough?'];
    ans2=snapshot.documents[1]['Do you have fever?is it responding to paracetamol?'];
    ans3=snapshot.documents[1]['Do you have breathlessness?'];
    ans4=snapshot.documents[1]['Travelled interstate/international in past 30 days?'];
    ans5=snapshot.documents[1]['Do you have cold/nose block/running nose?'];
    social = snapshot.documents[0]['red'];
    DBdate = snapshot.documents[0]['date'];
    globales.red = snapshot.documents[0]['red'];
    cough = snapshot.documents[0]['cough'];

    /*Firestore.instance.collection('info').document('$userName').collection('Activities').getDocuments().then((QuerySnapshot snapshot) {
      social = snapshot.documents[0]['red'];
    });*/
    print(userName);
    print("DBdateup:$DBdate");
    print("globalesup:${globales.red}");
    ans1=ans1.trim().toLowerCase();
    ans2=ans2.trim().toLowerCase();
    ans3=ans3.trim().toLowerCase();
    ans4=ans4.trim().toLowerCase();
    ans5=ans5.trim().toLowerCase();

    print("globes:$ans1");
    print("globes:$ans2");
    print("globes:$ans3");
    print("globes:$ans4");
    print("globes:$ans5");
    print(social);

    counts =0;
    if(ans1 == 'yes')
    {
      counts = counts+1;
      q1='Cough \n';
      print(counts);
    }
    if( ans2 =='yes' )
    {
      counts = counts+1;
      q2='Fever \n';
      print(counts);
    }
    if( ans3 == 'yes' )
    {
      counts = counts+1;
      q3='Breathlessness \n';
      print(counts);
    }
    if( ans4 == 'yes' )
    {
      counts = counts+1;
      q4 ='Travelled interstate/international in past 30 days \n';
      print(counts);
    }
    if( ans5 == 'yes' )
    {
      counts = counts+1;
      q5='cold \n';
      print(counts);
    }

    print("count$counts");
    if(int.parse(social) > 6) {
      analysis1 = 1;
      q6 = '\nyou did not follow social distancing and you have violated $social times.';
    }
    else{
      q6 = '\nyou are successfully following social distancing,please  continue to do this.';
    }
    print(counts);

    if(counts > 2) {
      analysis2 = 1;
      q7="\nImmediately consult a doctor in a nearby health center.";
    }

    if(cough > 15 ){
      analysis3 = 1;
      q8 = "\n You have coughed/snezzed beyond the safer limit.";
    }
    else{
      q8 = "\n your cough/sneeze is within the safer limit.";
    }

    print("A1$analysis1");
    print("A2$analysis2");
    print("A3$analysis3");

    if(analysis2 == 1)
      color = 'red';
    else if(analysis1 == 0 && analysis2 == 0 && analysis3 == 0)
      color = 'green';
    else
      color = 'yellow';
    String q0='You have :\n';
    info = q0+q1+q2+q3+q5+q4+q6+q8+q7;
    print(color);
    if (counts == 0)
      info = "\n you are free from all symptoms \n please maintain social distancing\n"+q6+q8;
    //  );
  });
}

  Future<void> initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: onSelectNotification);
  }

  //void _showNotifications()async{
    //print("hi");
    //await notification();
  //}

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
  }
  Future<Album> createAlbum(double latitude, double longitude) async {
    final http.Response response = await http.post(
      'https://ceg-covid.herokuapp.com/latlong',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, double>{
        'lat': latitude,
        'long': longitude,
      }),
    );
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = jsonDecode(data);
      print("data:$decodedData"); //"status": "Success"
      String postResult = decodedData['status'];
      if (postResult == "Success") {
        http.Response getResponse = await http.get(
            'https://ceg-covid.herokuapp.com/getValues');
        //print("$response.statuscode");
        var y = getResponse.statusCode;
        print("get statuscode:$y");
        if (getResponse.statusCode == 200) {
          var getData = getResponse.body;
          //print("data:$decodedData");
          var getDecodedData = jsonDecode(getData);
          print("data:$getDecodedData");
          distance = getDecodedData['value'].toString();
          print("dis:$distance");
        }
      }
    }

    double data = double.parse(distance);
    double dis_m = data * 1000;
    print("notify dis:$dis_m");


    if (dis_m < 1.0 ) {
      Firestore.instance.collection('info')
          .document(
          '$userName')
          .collection('Activities')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        DBdate = snapshot.documents[0]['date'];
        globales.red = snapshot.documents[0]['red'];
      });
      print("DB date$DBdate");
      print("todaydate$todaydate");
      print("DBUSER$userName");
      print("globales :${globales.red}");
      if(DBdate == todaydate) {
        print("todaydate$todaydate");

        int r = int.parse(globales.red);
        r = r + 1;
        globales.red = r.toString();
        print("globales red${globales.red}");
        _fs.collection('info').document(
            '$userName').collection(
            'Activities')
            .document('Activity 1')
            .updateData({
          //'count': globales.count,
          'red': globales.red,
        });
        notification();
      }
      else
      { print("ekse");
      _fs.collection('info').document(
          '$userName').collection(
          'Activities')
          .document('Activity 1')
          .updateData({
        //'count': globales.count,
        'red': '0',
        'cough': 0,
        'date': todaydate,
      });
      notification();
      }
    }
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
          Center(
            child: Container(
              child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/load.gif'),
                      radius: 100.0,
                    ),Text("Please wait, data is processing",style: TextStyle(color: Colors.white),),
                    CircularProgressIndicator(),

                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  final FlutterTts flutterTts = FlutterTts();

  void initState(){
    flutterTts.setLanguage("en-IN");
    flutterTts.setPitch(1);
    flutterTts.speak("$info");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.black,

      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //Background(),
            Details(),
          ],
        ),
      ),
        bottomNavigationBar:CurvedNavigationBar(
          color: Colors.black,
          backgroundColor: Colors.blueGrey[700],
          buttonBackgroundColor: Colors.black,
          height: 70,
          index: 1,
          items: <Widget>[

            Icon(Icons.mic,size: 20, color: Colors.white),
            Icon(Icons.dashboard, size: 20, color: Colors.white),
           // Icon(Icons.today, size: 20, color: Colors.white),
          ],
            animationDuration: Duration(
                milliseconds: 313
            ),
            onTap: (index){
              if(index == 0){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Record()));
              }
            }
        )
    );
  }
}



class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //final _auth = FirebaseAuth.instance;
  final _fs = Firestore.instance;
  FirebaseUser fbuser;
  Widget build(BuildContext context) {
   print("username1$userName");
   print("counti $counts");
    print("color:$color");
    if(color == 'red')
    {
      _fs.collection('info').document('$userName').collection('Activities').document('Activity 1').updateData({
        'colour':color,
      });
      return Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(padding:EdgeInsets.only(top:20.0,left: 20.0),child: SvgPicture.asset('assets/bgr7.svg',height: 200.0,)),
/*            IconButton(
              onPressed: (){
                Details();
              },
              icon: Icon(Icons.person),
              color: Colors.red,
              iconSize: 200.0,
            ), */SizedBox(height: 40.0,),
              Container(
                  decoration:  BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      border: Border.all(width: 1.0,color: Colors.black),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        //bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(40.0),
                      )
                  ),
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 35.0),
                  child: Text("$info",style: TextStyle(color: Colors.red[900],fontSize: 20.0),)),
              //  Text(,style: TextStyle(color: Colors.red,fontSize: 12.0),),


            ],
          ),),
      );
    }
    else if(color == 'yellow')
    {
      _fs.collection('info').document('$userName').collection('Activities').document('Activity 1').updateData({
        'colour':color,
      });

      return Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(padding:EdgeInsets.only(top:20.0,left: 20.0),child: SvgPicture.asset('assets/bgy7.svg',height: 200.0,)),
                 SizedBox(height: 40.0,),
              Container(
                  decoration:  BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      border: Border.all(width: 1.0,color: Colors.black),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        //bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(40.0),
                      )
                  ),
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 35.0),
                  child: Text("\n$info",
                    style: TextStyle(
                        color: Colors.yellow[900], fontSize: 20.0),)),

            ],
          ),),
      );

    }
    if(color == 'green') {
      _fs.collection('info').document('$userName').collection('Activities').document('Activity 1').updateData({
        'colour':color,
      });
      return Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(padding:EdgeInsets.only(top:20.0,left: 20.0),child: SvgPicture.asset('assets/bgg7.svg',height: 200.0,)),
              /*IconButton(
                    onPressed: () {
                      Details();
                    },
                    icon: Icon(Icons.person),
                    color: Colors.green,
                    iconSize: 200.0,
                  ),*/ SizedBox(height: 40.0,),
              Container(
                  decoration:  BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      border: Border.all(width: 1.0,color: Colors.black),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        //bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(40.0),
                      )
                  ),
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 35.0),
                  child: Text("$info",
                    style: TextStyle(
                        color: Colors.green[900], fontSize: 20.0),)),
            ],
          ),
        ),
      );
    }
  }

}
class Album {
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