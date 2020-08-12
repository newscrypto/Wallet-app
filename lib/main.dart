import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newscrypto_wallet/screens/header/Header.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/widgets/Fab.dart';

import 'models/Trnsaction.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff26364F),
        accentColor: Color(0xff3D4D66),
        backgroundColor: Color(0xff3D4D66),

        brightness: Brightness.dark,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SliverAppBarSnap(),
        ),
      ),
    );
  }
}

class SliverAppBarSnap extends StatefulWidget {
  @override
  _SliverAppBarSnapState createState() => _SliverAppBarSnapState();
}

class _SliverAppBarSnapState extends State<SliverAppBarSnap> {
  List<WalletTransaction> _data = [];
  final _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  double get maxHeight =>
      MediaQuery.of(context).size.height * 0.5 +
      MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  bool isEmpty = false;

  Future<List<WalletTransaction>> _future;

  @override
  void initState() {
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd) {
        setState(() {
          _future = loadData();
        });
      }
    });
    _future = loadData();
    super.initState();
  }

  var random = new Random();

  Future<List<WalletTransaction>> getTransactions(var cursor) async {
    List<WalletTransaction> walletTransaction =
        await getAccountTransactions(cursor);
    return walletTransaction;
  }

  Future<List<WalletTransaction>> loadData() async {
    var cursor = "now";
    if (_data.isNotEmpty) {
      cursor = _data[_data.length - 1].paginationToken;
    }
    print(cursor);
    var tracks = await getTransactions(cursor);
    _data.addAll(tracks);
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FabWidget(),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          _snapAppbar();
          return false;
        },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              flexibleSpace: HeaderState(
                maxHeight: maxHeight,
                minHeight: minHeight,
              ),
              expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
            ),
            FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<WalletTransaction> loaded = snapshot.data;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (loaded.length > index)
                          return _buildCard(loaded[index], index);
                        else
                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                "List is empty",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                      }, childCount: loaded.length),
                    );
                  } else
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "No transactions!",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                })
          ],
        ),
      ),
    );
  }

  Widget _buildCard(WalletTransaction transaction, index) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(transaction.received ? "Received" : "Sent"),
                      Text(transaction.createdAt),
                    ],
                  )
                ],
              )
            ],
          ),
          Container(
            child: Text(
              (transaction.received ? "+" : "-") + " ${transaction.amount} NWC",
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
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      margin: EdgeInsets.only(
          left: 20, right: 20, top: index == 0 ? 20 : 10, bottom: 10),
      padding: EdgeInsets.all(20),
    );
  }

  Container _transactionIcon(WalletTransaction transaction) {
    return Container(
      child: Icon(transaction.received ? Icons.call_received : Icons.call_made),
      margin: EdgeInsets.only(right: 15),
    );
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }
}
