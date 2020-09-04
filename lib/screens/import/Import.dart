import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/main.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/Logo.dart';
import 'package:newscrypto_wallet/widgets/SecondaryButton.dart';

class Import extends StatefulWidget {
  @override
  _ImportState createState() => _ImportState();
}

class _ImportState extends State<Import> with TickerProviderStateMixin {
  bool nwcAddressPasted = false;
  bool nwcMemoPasted = false;
  String secretKey = "Tap to paste secret key!";
  String errorText = "";

  @override
  void initState() {
    super.initState();
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
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Logo(),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: Text("Secret key:"),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          secretKey = value;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Text(errorText),
                    ),
                    SecondaryButton(
                      title: "Import wallet",
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 40,
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Palette.secondaryButtonDefault,
                      fontsize: 20,
                      function: () async {
                        try {
                          await importNewWallet(secretKey);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => SliverAppBarSnap()),
                              (Route<dynamic> route) => false);
                        } catch (e) {
                          setState(() {
                            errorText = e;
                          });
                        }
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
