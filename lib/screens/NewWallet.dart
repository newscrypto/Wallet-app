import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/models/Activation.dart';
import 'package:newscrypto_wallet/screens/pincode/PinCode.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/services/Activation.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
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
  String copyText = "Tap address to copy";
  Color copyTextColor = Colors.white;

  @override
  void initState() {
    generateNewWallet();
    super.initState();
  }

  void generateNewWallet() async {
    String address = await createNewWallet();
    setState(() {
      _publicKey = address;
    });
    getActivationInfo();
  }

  void getActivationInfo() async {
    ActivationInfo newActivationInfo = await fetchActivationInfo(_publicKey);
    if (newActivationInfo.activated) {
      setActivate(true);
      bool trustline = await createNWCTrustLine();
      if (trustline) {
        getChange(_publicKey);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PinCodeVerificationScreen(),
          ),
        );
      }
    }
    setState(() {
      _activationInfo = newActivationInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fontsize = width > 370 ? 20 : 16;
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
                  colors: <Color>[Colors.transparent, Colors.black26])),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          BackgroundStack(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "To activate wallet send ${_activationInfo.amount} NWC to following address and memo and then press activate:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                margin: EdgeInsets.only(bottom: 30),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding: EdgeInsets.all(5),
                child: QrImage(
                  data: _activationInfo.address,
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width * 0.4,
                  gapless: false,
                  embeddedImage: AssetImage('assets/images/logo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(20, 20),
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
                      copyText = "Tap address to copy";
                      copyTextColor = Colors.white;
                    });
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
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
              Container(
                child: Text(
                  "Memo:",
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 10, bottom: 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  _activationInfo.memo,
                  textAlign: TextAlign.center,
                ),
              ),
              SecondaryButton(
                title: "Activate",
                width: MediaQuery.of(context).size.width * 0.8,
                fontsize: fontsize,
                margin: EdgeInsets.only(top: 5),
                color: Palette.primaryButtonDefault,
                function: () {
                  getActivationInfo();
                },
              ),
            ],
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
