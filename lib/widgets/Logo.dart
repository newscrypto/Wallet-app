import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.25),
      width: MediaQuery.of(context).size.width * 0.55,
      child: Image.asset("assets/images/logo.png"),
    );
  }
}
