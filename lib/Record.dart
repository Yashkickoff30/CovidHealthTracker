import 'dart:io' as io;
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:frontend1db/Dashboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
//import 'package:frontend1db/Cough.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class Record extends StatefulWidget {
  @override
  _RecordState createState() => new _RecordState();
}

final _auth = FirebaseAuth.instance;
final _fs = Firestore.instance;
String userName;
String date;
int cough;

class _RecordState extends State<Record> {

  void initState() {

    super.initState();
    getUser();
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
      }
      else{
        SharedPreferences logindata =await SharedPreferences.getInstance();
        logindata = await SharedPreferences.getInstance();
        userName=logindata.getString('username');
        date=logindata.getString('date');
        print(userName);
      }

      _fs.collection('info').document('$userName').collection('Activities').getDocuments().then((QuerySnapshot snapshot) {
        cough = snapshot.documents[0]['cough'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700],
      appBar: AppBar(
        title: Text("Record Audio"),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading:new Container(),
      ),
      resizeToAvoidBottomPadding: false,
      body:Stack(
        children: <Widget>[
          // background(),
          Container(padding:EdgeInsets.only(top:150.0,left: 50.0),child: SvgPicture.asset('assets/bg5.svg',height: 200.0,)),
          AppBody(),
        ],
      ),
        bottomNavigationBar:CurvedNavigationBar(
            color: Colors.black,
            backgroundColor: Colors.blueGrey[700],
            buttonBackgroundColor: Colors.black,
            height: 70,
            index: 0,
            items: <Widget>[
              Icon(Icons.mic,size: 20, color: Colors.white),
              Icon(Icons.dashboard, size: 20, color: Colors.white),
             // Icon(Icons.today, size: 20, color: Colors.white),
            ],
            animationDuration: Duration(
                milliseconds: 313
            ),
            onTap: (index){
              if(index == 1){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dashboard()));
              }
            }
        )
    );
  }
}

class AppBody extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  AppBody({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new AppBodyState();
}

class AppBodyState extends State<AppBody> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();
String info;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: new Center(

          child: new Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
              Container(
                  padding:EdgeInsets.only(top:10.0,left: 0.0,right: 0.0),
                  child: Column(
                    children: <Widget>[
                      new IconButton(icon: Icon(Icons.mic,),
                        onPressed: _isRecording ? null : _start,iconSize: 40.0,color: Colors.green,),
                      Text("Start",style: TextStyle(fontSize: 20.0,color: Colors.green),),

                    ],
                  ),
                ),
                Container(
                  padding:EdgeInsets.only(top:0.0,left: 0.0,right: 0.0,bottom: 100.0),
                  child: Column(
                    children: <Widget>[
                      new IconButton(
                        icon: Icon(Icons.stop,color: Colors.red,),
                        onPressed: _isRecording ? _stop : null,iconSize: 40.0,),
                         Text("Stop",style: TextStyle(fontSize: 20.0,color: Colors.red)),

                    ],
                  ),
                ),
      Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
      margin: EdgeInsets.only(top:0.0,bottom: 30.0,right:0.0),

      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.7),
      border: Border.all(width: 1.0,color: Colors.black87),
      borderRadius: BorderRadius.only(
      topRight: Radius.circular(20.0),
      bottomLeft: Radius.circular(20.0),
      // bottomRight: Radius.circular(20.0),
      ),
      ),
               child: Container(
                  child: new TextField(
                    controller: _controller,
                    decoration: new InputDecoration(
                      hintText: 'Enter a path to store:',
                    ),
                  ),
                ),),
                Container(
                  //padding: EdgeInsets.all(20.0),
                  padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 15.0),
                  margin: EdgeInsets.only(top:0.0,bottom: 0.0,right:0.0),

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
                    Container(child: new Text("File path of the record: ${_recording.path}\n",)),
                    //new Text("Format: ${_recording.audioOutputFormat}\n"),
                    new Text("Extension : ${_recording.extension}\n"),
                    new Text("Audio recording duration : ${_recording.duration.toString()}\n")
                  ],
                ),
      ),
                Container(
                  padding:EdgeInsets.only(top:0.0,left: 0.0,right: 0.0,bottom: 0.0),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(onPressed: (){

                        cough = cough +1;
                        _fs.collection('info').document(
                            '$userName').collection(
                            'Activities')
                            .document('Activity 1')
                            .updateData({
                          'cough':cough
                        });
                      },
                      child: Text('ok',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),),
                      ),

                    ],
                  ),
                ),
              ]
          ),
      ),
    );
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        if (_controller.text != null && _controller.text != "") {
          String path = _controller.text;
          if (!_controller.text.contains('/')) {
            io.Directory appDocDirectory =
            await getApplicationDocumentsDirectory();
            path = appDocDirectory.path + '/' + _controller.text;
          }
          print("Start recording: $path");
          await AudioRecorder.start(
              path: path, audioOutputFormat: AudioOutputFormat.AAC);
        } else {
          await AudioRecorder.start();
        }
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: _recording.path);
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);

      String i=e.toString();

      info = i;
      print(info);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Message"),
            content: new Text("$info"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("ok"),
                onPressed: () {
                  Navigator.of(context).pop();},),
            ],);},);

    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = widget.localFileSystem.file(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
    _controller.text = recording.path;
  }


Future<String> uploadAudio(filepath) async {
    var request = http.MultipartRequest('POST',Uri.parse('https://ceg-covid.herokuapp.com/audio',));
    request.files.add(await http.MultipartFile.fromPath(filepath,'audio'));
    var res = await request.send();
    print(res);
    final response = await http.get('https://ceg-covid.herokuapp.com/audio');

   if(response.statusCode == 200)
    {
      print(response);
    }
    else
      {
        throw Exception("file not found");
      }
    //return res.reasonPhrase;
}
}