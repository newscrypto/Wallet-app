import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/models/Trnsaction.dart';

class InfiniteScroll extends StatefulWidget {
  @override
  _InfiniteScrollState createState() => new _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  List<Transaction> _data = [];
  Future<List<Transaction>> _future;
  int _currentPage = 1;
  ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
  bool allData = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd && !allData) {
        setState(() {
          _future = loadData();
        });
      }
    });
    _future = loadData();
    super.initState();
  }

  var random = new Random();

  Future<List<Transaction>> getTransactions() {
    List<Transaction> transactions = new List<Transaction>();
    for (var i = 1; i < 50; i++) {
      var receiveInt = random.nextInt(100);
      var amount = random.nextInt(10000);
      var transaction = Transaction(
        id: i,
        name: "transaction $i",
        received: receiveInt > 50,
        amount: amount.toDouble(),
      );
      transactions.add(transaction);
    }
    return Future.value(transactions);
  }

  Future<List<Transaction>> loadData() async {
    var tracks = await getTransactions();
    _data.addAll(tracks);
    _currentPage++;
    return _data;
  }

  Container _transactionIcon(Transaction transaction) {
    return Container(
      child: Icon(transaction.received ? Icons.call_received : Icons.call_made),
      margin: EdgeInsets.only(right: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Transaction> loaded = snapshot.data;
            return ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: loaded.length + 1,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                if (index < loaded.length) {
                  Transaction transaction = loaded[index];
                  return Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                _transactionIcon(transaction),
                                Text(
                                    transaction.received ? "Received" : "Sent"),
                              ],
                            )
                          ],
                        ),
                        Container(
                          child: Text(
                            (transaction.received ? "+" : "-") +
                                " ${transaction.amount} NWC",
                            style: TextStyle(
                                color: transaction.received
                                    ? Colors.lightGreen
                                    : Colors.deepOrangeAccent),
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.all(20),
                  );
                } else {
                  return Opacity(
                      opacity: allData ? 0 : 1,
                      child: Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      )));
                }
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
