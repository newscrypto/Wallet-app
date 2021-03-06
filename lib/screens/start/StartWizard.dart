import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/PushNotificationManager.dart';
import 'package:newscrypto_wallet/screens/NewWallet.dart';
import 'package:newscrypto_wallet/screens/import/Import.dart';
import 'package:newscrypto_wallet/screens/pincode/PinCode.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/Logo.dart';
import 'package:newscrypto_wallet/widgets/PrimaryButton.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';

class StartWizard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fontsize = width > 370 ? 12 : 10;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          BackgroundStack(),
          // Align(
          //   alignment: Alignment.center,
          //   child: Logo(),
          // ),
          Center(
            child: Logo(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(children: [
                  Container(
                    height: 30,
                  ),
                  Text(
                    "WELCOME",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text("to the NewsCrypto wallet"),
                ]),
                Column(
                  children: [
                    PrimaryButton(
                      title: "Create new wallet",
                      width: width * 0.7,
                      fontsize: fontsize,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(15),
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewWallet(),
                          ),
                        );
                      },
                    ),
                    PrimaryButton(
                      title: "Import existing wallet",
                      width: width * 0.7,
                      fontsize: fontsize,
                      margin: EdgeInsets.only(top: 10, bottom: 40),
                      padding: EdgeInsets.all(15),
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Import()),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
