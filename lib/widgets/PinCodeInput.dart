import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PinInput extends StatelessWidget {
  final int inputLength;
  final String title;

  PinInput({this.inputLength, this.title});

  List<Widget> _pinCodeCircles() {
    List<Widget> circles = new List();
    for (int i = 0; i < 6; i++) {
      circles.add(Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: inputLength - 1 >= i ? Colors.white70 : Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 3,
            )),
      ));
    }
    return circles;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _pinCodeCircles(),
      )
    ]);
  }
}
