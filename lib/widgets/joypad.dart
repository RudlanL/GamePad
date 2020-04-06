import 'dart:math';
import 'package:flutter/material.dart';

typedef JoyPadCallback = void Function(Offset);
class Joypad extends StatefulWidget {
  
  final JoyPadCallback onDirectionChanged;

  const Joypad({
    Key key,
    @required this.onDirectionChanged,
  }) : super(key : key);
  

  JoypadState createState() => JoypadState();
}

class JoypadState extends State {
  Offset delta = Offset.zero;
  double actualSize = 0;

  bool isLeft = false;
  bool isRight = false;

  void updateDelta(Offset newDelta) {
    setState(() {
      delta = newDelta;
    });
    _processGesture(newDelta);
  }

  void calculateDelta(Offset offset) {
    Offset newDelta = offset - Offset(actualSize / 2, actualSize / 2);
    updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(30, newDelta.distance),
      ),
    );
  }

  Widget build(BuildContext context) {
    actualSize = min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) * 0.5;
    return SizedBox(
      height: actualSize,
      width: actualSize,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(actualSize / 2),
        ),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0x88000000),
              borderRadius: BorderRadius.circular(actualSize / 2),
            ),
            child: Center(
              child: Transform.translate(
                offset: delta * 2,
                child: SizedBox(
                  height: actualSize / 4,
                  width: actualSize / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xccffffff),
                      borderRadius: BorderRadius.circular(actualSize / 4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          onPanDown: onDragDown,
          onPanUpdate: onDragUpdate,
          onPanEnd: onDragEnd,
        ),
      ),
    );
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }

  void _processGesture(Offset delta) {
    print("DIRECTION :${delta.dx}");
  }
}