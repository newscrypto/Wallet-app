import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/main.dart';
import 'package:newscrypto_wallet/screens/pincode/PinCode.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/Logo.dart';
import 'package:newscrypto_wallet/widgets/PrimaryButton.dart';
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
              alignment: Alignment.center,
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
                        color: Colors.white12,
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
                      child: Text(
                        errorText,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    Center(
                      child: PrimaryButton(
                        title: "Import existing wallet",
                        width: MediaQuery.of(context).size.width * 0.7,
                        fontsize: 12,
                        margin: EdgeInsets.only(top: 10, bottom: 40),
                        padding: EdgeInsets.all(15),
                        function: () async {
                          try {
                            await AccountApi().importNewWallet(secretKey);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PinCodeVerificationScreen(),
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              errorText = e;
                            });
                          }
                        },
                      ),
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
