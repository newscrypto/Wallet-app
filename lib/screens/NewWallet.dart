import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/models/Activation.dart';
import 'package:newscrypto_wallet/screens/SecretKeyPage.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/services/Activation.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/PrimaryButton.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NewWallet extends StatefulWidget {
  @override
  _NewWalletState createState() => _NewWalletState();
}

class _NewWalletState extends State<NewWallet> with TickerProviderStateMixin {
  bool nwcAddressPasted = false;
  bool nwcMemoPasted = false;
  String secretKey = "Tap to paste secret key!";
  String errorText = "";
  ActivationInfo _activationInfo =
      new ActivationInfo(address: "", memo: "", amount: 0);
  String _publicKey = "";
  String copyText = "Tap to copy";
  String copyMemoText = "Tap to copy";
  Color copyTextColor = Colors.white;
  Color copyMemoTextColor = Colors.white;
  bool _loading = false;

  @override
  void initState() {
    generateNewWallet();
    super.initState();
  }

  void generateNewWallet() async {
    String address = await AccountApi().createNewWallet();
    setState(() {
      _publicKey = address;
    });
    ActivationInfo newActivationInfo =
        await ActivationApi().fetchActivationInfo(_publicKey);
    setState(() {
      _activationInfo = newActivationInfo;
    });
  }

  void getActivationInfo() async {
    setState(() {
      _loading = true;
    });
    ActivationInfo newActivationInfo =
        await ActivationApi().fetchActivationInfo(_publicKey);
    if (newActivationInfo.activated) {
      AccountApi().setActivate(true);
      bool trustline = await AccountApi().createNWCTrustLine();
      if (trustline) {
        ActivationApi().getChange(_publicKey);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecretKeyPage(),
          ),
        );
      }
    }
    setState(() {
      _activationInfo = newActivationInfo;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fontsize = width > 370 ? 12 : 10;
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("Receive"),
      //   backgroundColor: Colors.transparent,
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       color: Colors.transparent,
      //     ),
      //   ),
      // ),
      backgroundColor: Theme.of(context).primaryColor,
      body:
      Stack(
        children: [
          BackgroundStack(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "To activate your wallet, send at least ${_activationInfo.amount} NWC to the address listed below with the provided memo. \n\n The remaining funds will be automatically transferred to your new wallet after creation.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    margin: EdgeInsets.only(bottom: 30, top: 50),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Theme.of(context).primaryColor,
                    ),
                    padding: EdgeInsets.all(5),
                    child: QrImage(
                      data: _activationInfo.address,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.5,
                      gapless: false,
                      embeddedImage:
                          AssetImage('assets/images/logo-with-bg.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(40, 40),
                      ),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  Container(
                    child: Text(
                      "Address:",
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(top: 40, bottom: 10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: _activationInfo.address));
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
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white12,
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _activationInfo.address,
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
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: _activationInfo.memo));
                      setState(() {
                        copyMemoText = "Copied!";
                        copyMemoTextColor = Colors.greenAccent;
                      });
                      Timer(Duration(seconds: 3), () {
                        setState(() {
                          copyMemoText = "Tap to copy";
                          copyMemoTextColor = Colors.white;
                        });
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white12,
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        _activationInfo.memo,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      copyMemoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: copyMemoTextColor),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  PrimaryButton(
                    title: "Activate",
                    width: width * 0.7,
                    fontsize: fontsize,
                    margin: EdgeInsets.only(top: 10, bottom: 40),
                    padding: EdgeInsets.all(15),
                    function: getActivationInfo,
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.black54),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Palette.primaryButtonDefault),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
