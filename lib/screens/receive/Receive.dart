import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class Receive extends StatefulWidget {
  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
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
        title: Text("Receive"),
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
            child: QrImage(
              data: getAccountID(),
              version: QrVersions.auto,
              size: MediaQuery.of(context).size.width * 0.6,
              gapless: false,
              embeddedImage: AssetImage('assets/images/logo.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(50, 50),
              ),
              foregroundColor: Colors.white,
            ),
          ),
          Container(
            child: Text(
              "Your NWC address:",
              textAlign: TextAlign.center,
            ),
            margin: EdgeInsets.only(top: 40, bottom: 10),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: getAccountID()));
              setState(() {
                copyText = "Copied!";
                copyTextColor = Colors.greenAccent;
              });
              Timer(Duration(seconds: 3), () {
                setState(() {
                  copyText = "Tap address to copy";
                  copyTextColor = Colors.white;
                });
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                getAccountID(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            child: Text(
              copyText,
              textAlign: TextAlign.center,
              style: TextStyle(color: copyTextColor),
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10),
          ),
          FlatButton(
            onPressed: () {
              Share.share('My nwc address is:\n ${getAccountID()}');
            },
            child: Text(
              "Share",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}
