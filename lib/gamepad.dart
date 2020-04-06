import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'bluetooth.dart';
import 'package:control_pad/control_pad.dart';
import 'package:gamepad/models/gamepadStatement.dart';
import 'widgets/joypad.dart';


class GamePadPage extends StatefulWidget {
  GamePadPage({Key key, this.title, this.device}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  BluetoothDevice device;

  @override
  _GamePadState createState() => _GamePadState();
}
class _GamePadState extends State<GamePadPage>{
  GamePadStatement gameState = new GamePadStatement();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    /*
    JoystickDirectionCallback onDirectionChanged(double degrees, double distance){
      // print("Degree : ${degrees.toStringAsFixed(2)} , distance : ${distance.toStringAsFixed(2)}");
      print();
    }*/

    JoyPadCallback onDirectionChanged(Offset delta) {
      print(delta);
    }

    PadButtonPressedCallback padButtonPressedCallback(int buttonIndex, Gestures gesture){
      gameState.gamePadButtonB = buttonIndex == 0 && gesture == Gestures.TAP ? true : false;
      gameState.gamePadButtonA = buttonIndex == 1 && gesture == Gestures.TAP ? true : false;
      gameState.gamePadButtonX = buttonIndex == 2 && gesture == Gestures.TAP ? true : false;
      gameState.gamePadButtonY = buttonIndex == 3 && gesture == Gestures.TAP ? true : false;
    }
    if(widget.device != null ){
      Timer.periodic(new Duration(seconds: 2), (timer)=>{
        debugPrint(timer.toString())
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
      child:ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('GamePad'),
            onTap: () => {
            },
          ),
          ListTile(
            title: Text('Devices List'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothList(title: 'Devices List',)))
            },
          ),
        ],
      ) ,
    ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //JoystickView(onDirectionChanged: onDirectionChanged),
            Joypad(onDirectionChanged: onDirectionChanged),
            Expanded(
              flex: 2,
              child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTapDown: (TapDownDetails details){
                      setState(() {
                        gameState.gamePadButtonSelect = true;
                      });
                    },
                    onTapCancel: (){
                      setState(() {
                        gameState.gamePadButtonSelect = false;
                      });
                    },
                    child: 
                      FloatingActionButton(
                        heroTag: "select",
                        onPressed: () => {},
                        child: Icon(Icons.aspect_ratio),
                        backgroundColor: Colors.black26,
                      ),
                  ),
                  GestureDetector(
                    onTapDown: (TapDownDetails details){
                      setState(() {
                        gameState.gamePadButtonSelect = true;
                      });
                    },
                    onTapCancel: (){
                      setState(() {
                        gameState.gamePadButtonSelect = false;
                      });
                    },
                    child: 
                      FloatingActionButton(
                        heroTag: "start",
                        onPressed: () => {},
                        child: Icon(Icons.list),
                        backgroundColor: Colors.black26,
                      )
                  ),
                ],
              ),
            ),
            ),
            PadButtonsView(
              padButtonPressedCallback: padButtonPressedCallback,
              buttons: const [
                PadButtonItem(index: 0, buttonText: 'KICK', backgroundColor: Colors.red),
                PadButtonItem(index: 1, buttonText: 'ChipKick', backgroundColor: Colors.green),
                PadButtonItem(index: 2, buttonText: 'X', backgroundColor: Colors.lightBlue),
                PadButtonItem(index: 3, buttonText: 'DRIBBLE', backgroundColor: Colors.yellowAccent)
              ]
            ) ,
          ],
        ),
      ),
    );
  }
}