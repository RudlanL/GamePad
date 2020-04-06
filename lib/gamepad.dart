import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
  writeData(BluetoothCharacteristic characteristic, String data) async{
   List<int> bytes = utf8.encode(data);
   await characteristic.write(bytes);
  }

  void createChargerIcons(){

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    JoyPadCallback onDirectionChanged(Offset delta) {
      gameState.velocityNormal = delta.dx;
      gameState.velocityAngular = delta.dy;
    }

    PadButtonPressedCallback padButtonPressedCallback(int buttonIndex, Gestures gesture){
      if(buttonIndex == 0){
        if (gesture == Gestures.TAPDOWN) {
          gameState.gamePadButtonB = true;
        } else {
          gameState.gamePadButtonB = false;
        }
      }
      if(buttonIndex == 1){
        if (gesture == Gestures.TAPDOWN) {
          gameState.gamePadButtonA = true;
        } else {
          gameState.gamePadButtonA = false;
        }
      }
      if(buttonIndex == 2){
        if (gesture == Gestures.TAPDOWN) {
          gameState.gamePadButtonX = true;
        } else {
          gameState.gamePadButtonX = false;
        }
      }
      if(buttonIndex == 3){
        if (gesture == Gestures.TAPDOWN) {
          gameState.gamePadButtonY = true;
        } else {
          gameState.gamePadButtonY = false;
        }
      }
    }
    new Timer.periodic(Duration(seconds: 2),(Timer t) async {
      String json = jsonEncode(gameState);
      print(json);
      if(widget.device != null){
        List<BluetoothService> services = await widget.device.discoverServices();
        services.forEach((service){
          var characteristics = service.characteristics;
          for(BluetoothCharacteristic c in characteristics){
            writeData(c, gameState.toString());
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Joypad(onDirectionChanged: onDirectionChanged),
            PadButtonsView(
              padButtonPressedCallback: padButtonPressedCallback,
              buttons: const [
                PadButtonItem(index: 0, buttonText: 'KICK', backgroundColor: Colors.red, supportedGestures: [Gestures.TAPDOWN, Gestures.TAPCANCEL]),
                PadButtonItem(index: 1, buttonText: 'ChipKick', backgroundColor: Colors.green,  supportedGestures: [Gestures.TAPDOWN, Gestures.TAPCANCEL]),
                PadButtonItem(index: 2, buttonText: 'X', backgroundColor: Colors.lightBlue, supportedGestures: [Gestures.TAPDOWN, Gestures.TAPCANCEL]),
                PadButtonItem(index: 3, buttonText: 'DRIBBLE', backgroundColor: Colors.yellowAccent, supportedGestures: [Gestures.TAPDOWN, Gestures.TAPCANCEL])
              ]
            ) ,
          ],
        ),
      ),
    );
  }
}