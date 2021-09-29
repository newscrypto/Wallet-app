import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/screens/pinTransactionConfirm/PinTransactionConfirm.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/BackgroundSecondary.dart';
import 'package:newscrypto_wallet/widgets/PrimaryButton.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';

import '../../main.dart';

class ConfirmSend extends StatefulWidget {
  final double sendAmountNWC;
  final double sendAmountUSD;
  final String sendToAddress;
  final String sendToMemo;

  ConfirmSend({
    @required this.sendAmountNWC,
    @required this.sendAmountUSD,
    @required this.sendToAddress,
    @required this.sendToMemo,
  });

  @override
  _ConfirmSendState createState() => _ConfirmSendState();
}

class _ConfirmSendState extends State<ConfirmSend> {
  bool _confirm = false;
  bool _loading = false;

  void pinConfirm() async {
    setState(() {
      _confirm = false;
      _loading = true;
    });
    bool response = await AccountApi()
        .sendNWC(widget.sendToAddress, widget.sendToMemo, widget.sendAmountNWC);
    if (response) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SliverAppBarSnap()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Confirm"),
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
          BackgroundSecondaryStack(),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.input,
                  ),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "${widget.sendAmountUSD.toStringAsFixed(2)} USD",
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "${widget.sendAmountNWC} NWC",
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text("Address:"),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.input,
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "${widget.sendToAddress}",
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text("Memo:"),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.input,
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "${widget.sendToMemo}",
                    textAlign: TextAlign.center,
                  ),
                ),
                // ),
                Center(
                  child: SecondaryButton(
                      title: "Confirm",
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.only(top: 40, bottom: 10),
                      function: () async {
                        setState(() {
                          _confirm = true;
                        });
                      }),
                ),
                SecondaryButton(
                  title: "Cancel",
                  width: MediaQuery.of(context).size.width * 0.5,
                  isTransparent: true,
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  color: Palette.secondaryButtonDefault,
                  function: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          if (_confirm)
            PinTransactionConfirm(
              onComplete: pinConfirm,
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
}
