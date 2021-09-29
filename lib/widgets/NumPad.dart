import 'package:flutter/material.dart';

import 'NumberButton.dart';

class NumPad extends StatelessWidget {
  final Function(String number) onNumberTap;

  List<Widget> _createButtons(int start, int end) {
    List<Widget> buttons = [];
    for (int i = start; i <= end; i++) {
      buttons.add(NumberButton(
        name: i.toString(),
        function: onNumberTap,
      ));
    }
    return buttons;
  }

  NumPad({this.onNumberTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _createButtons(1, 3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _createButtons(4, 6),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _createButtons(7, 9),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _createButtons(0, 0),
          ),
        ],
      ),
    );
  }
}
