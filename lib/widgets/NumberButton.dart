import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/screens/pincode/PinCode.dart';

class NumberButton extends StatelessWidget {
  final String name;
  final Function(String number) function;

  NumberButton({this.name, this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        height: MediaQuery.of(context).size.width * 0.15,
        minWidth: MediaQuery.of(context).size.width * 0.15,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Colors.white24)),
        child: Text(name),
        onPressed: () => {function(name)},
      ),
    );
  }
}
