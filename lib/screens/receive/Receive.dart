import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Receive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          QrImage(
            data: getAccountID(),
            version: QrVersions.auto,
            size: MediaQuery.of(context).size.width * 0.7,
            gapless: false,
            embeddedImage: AssetImage('assets/images/logo.png'),
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size(80, 80),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          Container(
            child: Text(getAccountID()),
          ),
          FlatButton(
            child: Text("Copy to the clipboard"),
            color: Colors.cyan,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: getAccountID()));
            },
          ),
        ],
      ),
    );
  }
}
