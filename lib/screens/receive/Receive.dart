import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/BackgroundSecondary.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class Receive extends StatefulWidget {
  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  String copyText = "Tap to copy";
  Color copyTextColor = Colors.white;
  String accountId = "";

  @override
  void initState() {
    copyText = "Tap to copy";
    copyTextColor = Colors.white;
    loadAccountId();
    super.initState();
  }

  void loadAccountId() async {
    String newAccountId = await AccountApi().getAccountID();
    setState(() {
      accountId = newAccountId;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Receive"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.transparent, Colors.transparent])),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          BackgroundSecondaryStack(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(5),
                child: QrImage(
                  data: accountId,
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width * 0.6,
                  gapless: false,
                  embeddedImage: AssetImage('assets/images/logo-black.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(50, 60),
                  ),
                  foregroundColor: Colors.white,
                ),
              ),
              Container(
                child: Text(
                  "Your NWC address:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                margin: EdgeInsets.only(top: 40, bottom: 10),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: accountId));
                  setState(() {
                    copyText = "Copied!";
                    copyTextColor = Colors.greenAccent;
                  });
                  Timer(Duration(seconds: 3), () {
                    setState(() {
                      copyText = "Tap to copy";
                      copyTextColor = Colors.white;
                    });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.input,
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    accountId,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
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
              Container(
                height: 30,
              ),
              SecondaryButton(
                title: "Share".toUpperCase(),
                width: MediaQuery.of(context).size.width * 0.5,
                fontsize: width > 370 ? 14 : 12,
                margin: EdgeInsets.only(top: 5),
                color: Colors.white,
                function: () {
                  Share.share('My nwc address is:\n $accountId');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
