import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/screens/import/Import.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/Logo.dart';
import 'package:newscrypto_wallet/widgets/PrimaryButton.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';

class StartWizard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fontsize = width > 370 ? 20 : 16;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Logo(),
                ),
                PrimaryButton(
                  title: "Create new wallet",
                  width: width * 0.7,
                  fontsize: fontsize,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(20),
                  function: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Import()),
                    );
                  },
                ),
                SecondaryButton(
                  title: "Import existing wallet",
                  margin: EdgeInsets.only(top: 10, bottom: 40),
                  width: width * 0.7,
                  color: Palette.secondaryButtonDefault,
                  fontsize: fontsize,
                  function: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Import()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
