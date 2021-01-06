import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Statistics.dart';
import 'package:newscrypto_wallet/screens/receive/Receive.dart';
import 'package:newscrypto_wallet/screens/send/Send.dart';

class FabWidget extends StatefulWidget {
  final Statistics statistic;
  final UserBalance balance;

  const FabWidget({Key key, this.statistic, this.balance}) : super(key: key);

  @override
  State createState() => FabWidgetState();
}

class FabWidgetState extends State<FabWidget> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    Color backgroundColor = Colors.blue;
    Color foregroundColor = Theme.of(context).accentColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve:
                  new Interval(0.0, 1.0 - 0 / 2 / 2.0, curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: true,
              child: Icon(Icons.call_received, color: foregroundColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Receive()),
                );
              },
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve:
                  new Interval(0.0, 1.0 - 1 / 2 / 2.0, curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              mini: true,
              child: Icon(Icons.call_made, color: foregroundColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Send(
                            statistic: widget.statistic,
                            balance: widget.balance,
                          )),
                );
              },
            ),
          ),
        ),
        new FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: new AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return new Transform(
                transform:
                    new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                alignment: FractionalOffset.center,
                child: new Icon(_controller.isDismissed
                    ? Icons.compare_arrows
                    : Icons.close),
              );
            },
          ),
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
        ),
      ],
    );
  }
}
