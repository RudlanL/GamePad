import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gamepad.dart';
import 'bluetooth.dart';

class MainMenu extends StatefulWidget{
  MainMenu({Key key, this.title}): super(key: key);

  final String title;
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(
              'images/app_icon.jpg',
              height: 100,
              width: 200,
            ),
            SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.60,
              child: RaisedButton(
                child: Text('GamePad'),
                onPressed: ()=>{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GamePadPage(title: 'GamePad')))
                },
              ),
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.60,
              child: RaisedButton(
                onPressed: ()=>{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothList(title: 'Devices List')))
                },
                child: Text('Devices List'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}