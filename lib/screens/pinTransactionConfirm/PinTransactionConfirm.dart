import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/widgets/Background.dart';
import 'package:newscrypto_wallet/widgets/BackgroundSecondary.dart';
import 'package:newscrypto_wallet/widgets/Biometric.dart';
import 'package:newscrypto_wallet/widgets/NumPad.dart';
import 'package:newscrypto_wallet/widgets/PinCodeInput.dart';
import 'package:vector_math/vector_math_64.dart';

class PinTransactionConfirm extends StatefulWidget {
  final Function() onComplete;

  PinTransactionConfirm({this.onComplete});

  @override
  _PinTransactionConfirmState createState() => _PinTransactionConfirmState();
}

class _PinTransactionConfirmState extends State<PinTransactionConfirm>
    with SingleTickerProviderStateMixin {
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
      duration: Duration(seconds: 1),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 40.0,
      end: 120.0,
    ).animate(animationController);
  }

  Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return Vector3(offset * 3, 0.0, 0.0);
  }

  void _onNumberTap(String number) async {
    if (currentText.length < 6)
      setState(() {
        currentText += number;
      });

    if (currentText.length == 6) {
      bool pinOk = await AccountApi().comparePin(currentText);
      if (pinOk) {
        widget.onComplete();
      } else {
        animationController.forward();
        setState(() {
          currentText = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      body: Stack(
        children: [
          BackgroundSecondaryStack(),
          BiometricAuth(onComplete: widget.onComplete),
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Transform(
                  transform: Matrix4.translation(_shake()),
                  child: PinInput(
                    inputLength: currentText.length,
                    title: "Enter pin to complete transaction",
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
                      child: Text("Back"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
