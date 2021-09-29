import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/main.dart';
import 'package:newscrypto_wallet/screens/pincode/PinCode.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/Logo.dart';
import 'package:newscrypto_wallet/widgets/PrimaryButton.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';

class SecretKeyPage extends StatefulWidget {
  bool backButton;

  SecretKeyPage({Key key, this.backButton = false}) : super(key: key);

  @override
  _SecretKeyState createState() => _SecretKeyState();
}

class _SecretKeyState extends State<SecretKeyPage> {
  bool nwcAddressPasted = false;
  bool nwcMemoPasted = false;
  String secretKey = "";
  String errorText = "";
  String copyText = "Tap to copy";
  Color copyTextColor = Colors.white;

  @override
  void initState() {
    super.initState();
    loadSecretKey();
  }

  void loadSecretKey() async {
    String secret = await AccountApi().getAccountSecret();
    setState(() {
      secretKey = secret;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      // resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: [
            BackgroundStack(),
            Center(
              child: Logo(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: Logo(),
                    // ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
                        child: Center(
                          child: Text(
                            "Save secret key for recovering wallet:",
                            textAlign: TextAlign.center,
                          ),
                        )),
                    GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: secretKey));
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
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white12,
                            ),
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              secretKey,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )),
                    Container(
                      child: Center(
                          child: Text(
                        copyText,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: copyTextColor),
                      )),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(
                    //     top: 10,
                    //     bottom: 10,
                    //     left: MediaQuery.of(context).size.width * 0.1,
                    //     right: MediaQuery.of(context).size.width * 0.1,
                    //   ),
                    //   child: Text(errorText),
                    // ),
                    widget.backButton
                        ? PrimaryButton(
                            title: "Close".toUpperCase(),
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 30,
                              left: MediaQuery.of(context).size.width * 0.1,
                              right: MediaQuery.of(context).size.width * 0.1,
                            ),
                            width: MediaQuery.of(context).size.width * 0.8,
                            // color: Palette.secondaryButtonDefault,
                            fontsize: 20,
                            function: () async {
                              Navigator.pop(context);
                            },
                          )
                        : PrimaryButton(
                            title: "Next".toUpperCase(),
                            margin: EdgeInsets.only(
                              top: 10,
                              bottom: 40,
                              left: MediaQuery.of(context).size.width * 0.1,
                              right: MediaQuery.of(context).size.width * 0.1,
                            ),
                            width: MediaQuery.of(context).size.width * 0.8,
                            // color: Palette.secondaryButtonDefault,
                            fontsize: 20,
                            function: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PinCodeVerificationScreen(),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
