import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/models/Balance.dart';

class BalanceWidget extends StatefulWidget {
  @override
  _BalanceState createState() => new _BalanceState();
}

class _BalanceState extends State<BalanceWidget> {
  Future<Balance> balance;

  @override
  void initState() {
    balance = getBalance();
    super.initState();
  }

  var random = new Random();

  Future<Balance> getBalance() {
    return Future.value(Balance(nwc: 10000, usd: 500));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: balance,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Balance loaded = snapshot.data;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Balance NWC"),
                      Text("${loaded.nwc} NWC")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Balance USD"),
                      Text("${loaded.usd} USD")
                    ],
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
