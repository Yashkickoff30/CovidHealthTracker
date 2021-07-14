import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:frontend1db/mainT.dart';
import 'InfoT.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart'as globales;
import 'package:background_location/background_location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:intl/intl.dart';


class LoginT extends StatelessWidget {
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

  FirebaseUser fbuser;
  String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            IconButton(padding:EdgeInsets.only(right: 40.0),onPressed:(){ Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppT()));}, icon:Icon(Icons.arrow_back),),
            Text(
              'பயனர் உள்நுழைவு',
            ),],
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        //padding: EdgeInsets.only(bottom: 10.0),
        color: Colors.blueGrey[700],
        child: Stack(
          children: <Widget>[
//SizedBox(width: 200.0,),
            Container(padding:EdgeInsets.only(top:200.0,left: 60.0),child: SvgPicture.asset('assets/bg5.svg',height: 200.0,)),
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  SharedPreferences logindata;
  bool newuser;
  String latitude = "waiting...";
  String longitude = "waiting...";
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";
  final _auth = FirebaseAuth.instance;
  String distance;
  String password;
  String info;
  String DBdate;
  final _fs = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  int bgcount;

  void initState() {
    bgcount = 0;
    super.initState();
    initializing();
  }

  Future<void> savedata() async{
    SharedPreferences logindata =await SharedPreferences.getInstance();
    logindata.setBool('login', false);
    logindata.setString('username', globales.email);
    logindata.setString('date',todaydate );
    logindata.setString('lang', 'tamil');
  }

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
                      globales.email = val;
                    },
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person, color: Colors.black, size: 40.0),
                        hintText: 'அஞ்சல் ஐடி',
                        hintStyle: TextStyle(color: Colors.black),
                        labelText: 'உங்கள் அஞ்சல் ஐடி',
                        labelStyle: TextStyle(color: Colors.black)),
                    validator:(email){
                      Pattern pattern =
                          r'^([a-z0-9_\-\.]+)@([a-z.]+)\.([a-z]{2,5})$';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(globales.email))
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
                        return 'தவறான கடவுச்சொல் \n ​​கடவுச்சொல் 6 எழுத்துகளுக்கு குறைவாக உள்ளது';
                      else
                        return null;
                    },
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 20.0, top: 40.0,bottom: 50.0),
                child: RaisedButton(
                    child: Text('உள்நுழைய', style: TextStyle(fontSize: 20.0,),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),

                    onPressed: ()async{
                      if(_formKey.currentState.validate()) {
                        dynamic newUser;
                        //DB validation
                        try {
                          newUser = await _auth.signInWithEmailAndPassword(
                              email: globales.email, password: password);
                        }
                        catch(e) {
                          print(e);
                          newUser=null;
                          String i=e.toString();
                          final startindex = i.indexOf('(');
                          final finalindex = i.indexOf(',');
                          info = i.substring(startindex,finalindex);
                        }

                        if (newUser != null) {
                          savedata();
                          Firestore.instance.collection('info')
                              .document(
                              '${globales.email}')
                              .collection('Activities')
                              .getDocuments()
                              .then((QuerySnapshot snapshot) {
                            globales.count = snapshot.documents[0]['count'];
                            DBdate = snapshot.documents[0]['date'];
                            globales.red = snapshot.documents[0]['red'];
                          });
                          print("DB date$DBdate");
                          print("globales:${globales.count}");
                          print("red${globales.red}");
                          BackgroundLocation.startLocationService();
                          BackgroundLocation.getLocationUpdates((location) {
                            if (bgcount == 10) {
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
                                """);
                            }
                            bgcount = bgcount + 1;
                            print("!@#$bgcount");
                          });
                          savedata();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("செய்தி"),
                                content: new Text("உள்நுழைந்துள்ளீர் \n${globales.email}",),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("சரி"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },),
                                ],);
                            },);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InfoT()),
                          );
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
                                      Navigator.of(context).pop();
                                    },),
                                ],);
                            },);
                        }

                        else if(info == "(ERROR_WRONG_PASSWORD")
                        {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("செய்தி"),
                                content: new Text("தவறான கடவுச்சொல்"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("சரி"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },),
                                ],);
                            },);
                        }

                        else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("செய்தி"),
                                content: new Text("மன்னிக்கவும் \n${globales.email} இல்லை"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  new FlatButton(
                                    child: new Text("சரி"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },),
                                ],);
                            },);
                        }}
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      'https://ceg-covid.herokuapp.com/getUserData',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'lat': latitude,
        'long': longitude,
        'id': globales.email,
      }),
    );
    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = jsonDecode(data);
      print("data:$decodedData"); //"status": "Success"
      String postResult = decodedData['response'];
      if (postResult == "Success") {
        http.Response getResponse = await http.get(
            'https://ceg-covid.herokuapp.com/getDistance?userid=${globales.email}');
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
          '${globales.email}')
          .collection('Activities')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        DBdate = snapshot.documents[0]['date'];
        globales.red = snapshot.documents[0]['red'];
      });
      print("DB date$DBdate");
      print("todaydate$todaydate");

      if(DBdate == todaydate) {
        print("todaydate$todaydate");

        int r = int.parse(globales.red);
        r = r + 1;
        globales.red = r.toString();
        print("globales red${globales.red}");
        _fs.collection('info').document(
            '${globales.email}').collection(
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
          '${globales.email}').collection(
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



