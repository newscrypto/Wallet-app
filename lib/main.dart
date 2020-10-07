import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Statistics.dart';
import 'package:newscrypto_wallet/screens/Login/Login.dart';
import 'package:newscrypto_wallet/screens/header/Header.dart';
import 'package:newscrypto_wallet/screens/start/StartWizard.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/services/PriceHistoryService.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Fab.dart';
import 'package:newscrypto_wallet/widgets/TransfareButton.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'models/Price.dart';
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
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff26364F),
        accentColor: Color(0xff3D4D66),
        backgroundColor: Color(0xff3D4D66),
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String>(
          future: getStartScreen(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty)
                return StartWizard();
              else if (snapshot.data == "startScreen")
                return StartWizard();
              else if (snapshot.data == "transactions")
                return SliverAppBarSnap();
              else if (snapshot.data == "login")
                return Login();
              else
                return StartWizard();
            } else {
              print("no data");
              return StartWizard();
            }
          }),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SliverAppBarSnap extends StatefulWidget {
  @override
  _SliverAppBarSnapState createState() => _SliverAppBarSnapState();
}

class _SliverAppBarSnapState extends State<SliverAppBarSnap>
    with TickerProviderStateMixin {
  List<WalletTransaction> _data = [];
  final _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  double get maxHeight =>
      MediaQuery.of(context).size.height * 0.5 +
      MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  bool isEmpty = false;

  Future<List<WalletTransaction>> _future;

  UserBalance balance = new UserBalance(nwc: 0, usd: 0);
  Statistics statistics;
  List<PriceHistory> prices;
  bool _loadingNewTransactions = false;

  @override
  void initState() {
    createNewNWCTrustLine();
    _controller.addListener(() {
      var isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd) {
        setState(() {
          _future = loadData();
        });
      }
    });
    _future = loadData();
    loadBalance();
    loadHistory();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var random = new Random();

  Future<void> refreshTransactions() async {
    _future = loadNewData();

    double nwcBalance = await getAccountBalance();
    Statistics nwcPrice = await fetchStats();
    setState(() {
      statistics = nwcPrice;
      balance =
          new UserBalance(nwc: nwcBalance, usd: nwcPrice.last * nwcBalance);
    });
    return _future;
  }

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
    var tracks = await getTransactions(cursor);
    _data.addAll(tracks);
    return _data;
  }

  Future<List<WalletTransaction>> loadNewData() async {
    var cursor = "now";
    if (_data.isNotEmpty) {
      cursor = _data[0].paginationToken;
    }
    List<WalletTransaction> walletTransaction =
        await getAccountNewTransactions(cursor);
    for (var transaction in walletTransaction) {
      _data.insert(0, transaction);
    }
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FabWidget(
        statistic: statistics,
        balance: balance,
      ),
      body: Stack(children: [
        NotificationListener<ScrollEndNotification>(
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
                onStretchTrigger: refreshTransactions,
                flexibleSpace: HeaderState(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                  balance: balance,
                  prices: prices,
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
                          if (loaded.length > index) {
                            if (index == 0 ||
                                (loaded[index - 1].dateTime.day !=
                                    loaded[index].dateTime.day)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (index == 0 && _loadingNewTransactions)
                                    Center(
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: EdgeInsets.only(top: 20),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Palette.primaryButtonDefault),
                                        ),
                                      ),
                                    ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                    ),
                                    child: Text(DateFormat.yMd()
                                        .format(loaded[index].dateTime)),
                                  ),
                                  _buildCard(loaded[index], index)
                                ],
                              );
                            }
                            return _buildCard(loaded[index], index);
                          } else
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
        AnimatedContainerApp(),
      ]),
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
                      Text(DateFormat.Hm().format(transaction.dateTime)),
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
                    ? Color(0xff00FFBB)
                    : Color(0xffff3369),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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

  void loadBalance() async {
    double nwcBalance = await getAccountBalance();
    Statistics nwcPrice = await fetchStats();

    setState(() {
      statistics = nwcPrice;
      balance =
          new UserBalance(nwc: nwcBalance, usd: nwcPrice.last * nwcBalance);
    });
  }

  void loadHistory() async {
    var startAt =
        (DateTime.now().subtract(Duration(days: 14)).millisecondsSinceEpoch /
                1000)
            .round();
    List<PriceHistory> _data = await fetchPriceHistory(startAt, "1day");
    setState(() {
      prices = _data;
    });
  }
}
