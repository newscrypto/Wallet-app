import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class Send extends StatefulWidget {
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  String copyText = "Tap address to copy";
  Color copyTextColor = Colors.white;

  @override
  void initState() {
    copyText = "Tap address to copy";
    copyTextColor = Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Send"),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              padding: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Amount of NWC'),
              )),
          TextFormField(
            decoration: InputDecoration(labelText: 'Enter your username'),
          ),
          Container(
            child: Text(
              "Your NWC address:",
              textAlign: TextAlign.center,
            ),
            margin: EdgeInsets.only(top: 40, bottom: 10),
          ),

        ],
      ),
    );
  }
}
