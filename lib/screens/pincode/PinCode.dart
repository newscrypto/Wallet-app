import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/screens/newPin/newPin.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/NumPad.dart';
import 'package:newscrypto_wallet/widgets/PinCodeInput.dart';
import 'package:vector_math/vector_math_64.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  PinCodeVerificationScreen();

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen>
    with SingleTickerProviderStateMixin {
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController);
  }

  Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return Vector3(offset * 4, 0.0, 0.0);
  }

  void _onNumberTap(String number) async {
    print(number);
    if (currentText.length < 6)
      setState(() {
        currentText += number;
      });

    if (currentText.length == 6) {
      await AccountApi().setPin(currentText);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewPin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      body: Stack(
        children: [
          BackgroundStack(),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Transform(
                    transform: Matrix4.translation(_shake()),
                    child: PinInput(
                      inputLength: currentText.length,
                      title: "Enter new pin code",
                    ),
                  ),
                ),
                Spacer(),
                NumPad(
                  onNumberTap: _onNumberTap,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text(""),
                      onPressed: () {},
                    ),
                    Opacity(
                      opacity: currentText.isNotEmpty ? 1 : 0,
                      child: FlatButton(
                        child: Text("Delete"),
                        onPressed: () {
                          if (currentText.isNotEmpty)
                            setState(() {
                              currentText = currentText.substring(
                                  0, currentText.length - 1);
                            });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
