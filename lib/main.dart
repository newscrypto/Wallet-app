import 'dart:math';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Statistics.dart';
import 'package:newscrypto_wallet/screens/Login/Login.dart';
import 'package:newscrypto_wallet/screens/SecretKeyPage.dart';
import 'package:newscrypto_wallet/screens/header/Header.dart';
import 'package:newscrypto_wallet/screens/pincode/PinCode.dart';
import 'package:newscrypto_wallet/screens/start/StartWizard.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/services/PriceHistoryService.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';
import 'package:newscrypto_wallet/widgets/Fab.dart';
import 'package:newscrypto_wallet/widgets/TransfareButton.dart';
import 'package:newscrypto_wallet/widgets/TrasactionContainer.dart';

import 'PushNotificationManager.dart';
import 'models/Price.dart';
import 'models/Trnsaction.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    PushNotificationsManager().init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff191415),
        accentColor: Colors.white,
        backgroundColor: Color(0xff191415),
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenApp(),
    );
  }
}

class SplashScreenApp extends StatefulWidget {
  @override
  _SplashScreenAppState createState() => new _SplashScreenAppState();
}

class _SplashScreenAppState extends State<SplashScreenApp> {
  loadFromFuture() async {
    String screen = await AccountApi().getStartScreen();
    Widget navigateTo;
    switch (screen) {
      case "startScreen":
        navigateTo = StartWizard();
        break;
      case "pinSetup":
        navigateTo = StartWizard();
        break;

      case "transactions":
        navigateTo = SliverAppBarSnap();
        break;

      case "login":
        navigateTo = Login();
        break;
      default:
        navigateTo = StartWizard();
    }
    navigateTo =
        await Future.delayed(const Duration(seconds: 1), () => navigateTo);
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => navigateTo));
  }

  @override
  void initState() {
    super.initState();
    loadFromFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
            0,
            0.3,
            1
          ],
              colors: [
            Color(0xFF314C9F),
            Color(0xFF314C9F),
            Color(0xff32AFEA)
          ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: Image.asset(
                    'assets/images/logo.png',
                  )))),
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
    AccountApi().createNewNWCTrustLine();
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

    double nwcBalance = await AccountApi().getAccountBalance();
    Statistics nwcPrice = await PriceApi().fetchStats();
    setState(() {
      statistics = nwcPrice;
      balance =
          new UserBalance(nwc: nwcBalance, usd: nwcPrice.last * nwcBalance);
    });
    return _future;
  }

  Future<List<WalletTransaction>> getTransactions(var cursor) async {
    List<WalletTransaction> walletTransaction =
        await AccountApi().getAccountTransactions(cursor);
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
        await AccountApi().getAccountNewTransactions(cursor);
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
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            controller: _controller,
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                onStretchTrigger: refreshTransactions,
                backgroundColor: Color(0xff191415),
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
                            if (index == loaded.length - 1) {
                              return Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  getTransactionContainer(loaded[index], 20),
                                  fillRemaining(loaded.length),
                                ],
                              ));
                            }
                            if (index == 0 ||
                                (loaded[index - 1].dateTime.day !=
                                    loaded[index].dateTime.day)) {
                              return getTransactionWithDate(loaded[index]);
                            }
                            return getTransactionContainer(loaded[index], 20);
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
    double nwcBalance = await AccountApi().getAccountBalance();
    Statistics nwcPrice = await PriceApi().fetchStats();
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
    List<PriceHistory> _data =
        await PriceApi().fetchPriceHistory(startAt, "1day");
    setState(() {
      prices = _data;
    });
  }

  Widget getTransactionContainer(transaction, double marginTop) {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: marginTop),
          width: MediaQuery.of(context).size.width * 0.8,
          child: TransactionHistoryContainer(
            transaction: transaction,
          )),
    );
  }

  Widget fillRemaining(allItems) {
    double remainingHeight = MediaQuery.of(context).size.height - allItems * 78;
    double remainingHeightPositive = remainingHeight < 0 ? 0 : remainingHeight;
    return Container(height: remainingHeightPositive);
  }

  Widget getTransactionWithDate(transaction) {
    return Center(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: Text(DateFormat.yMd().format(transaction.dateTime)),
                ),
                getTransactionContainer(transaction, 10),
              ],
            )));
  }
}
