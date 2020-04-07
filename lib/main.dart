import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamepad/menu.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'GamepadApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(title: 'Menu'),
    );
  }
}

