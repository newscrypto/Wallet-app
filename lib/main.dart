//import 'dart:math';
//import 'dart:ui';
//
//import 'package:flutter/material.dart';
//import 'package:newscrypto_wallet/widgets/TransactionList.dart';
//
//void main() {
//  runApp(MyApp());
//}
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//        primaryColor: Color(0xff26364F),
//        accentColor: Color(0xff3D4D66),
//        backgroundColor: Color(0xff3D4D66),
//
//        brightness: Brightness.dark,
//        // This makes the visual density adapt to the platform that you run
//        // the app on. For desktop platforms, the controls will be smaller and
//        // closer together (more dense) than on mobile platforms.
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: MyHomePage(title: 'Wallet'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return Scaffold(
//      backgroundColor: Theme.of(context).backgroundColor,
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
//      body: InfiniteScroll(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'models/Balance.dart';
import 'models/Trnsaction.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  List<Transaction> _data = [];

  final _controller =
      ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  double get maxHeight => 400 + MediaQuery.of(context).padding.top;

  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;

  bool isEmpty = false;

  Future<List<Transaction>> _future;

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

  Future<List<Transaction>> getTransactions() {
    List<Transaction> transactions = new List<Transaction>();
    for (var i = 1; i < 20; i++) {
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
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.forward),
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            isEmpty = !isEmpty;
          });
        },
      ),
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
              flexibleSpace: Header(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                  balance: Balance(nwc: 5000, usd: 1000)),
              expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
            ),
//            if (!isEmpty)
//              SliverList(
//                delegate: SliverChildBuilderDelegate(
//                  (context, index) {
//                    return _buildCard(index);
//                  },
//                ),
//              )
//            else
//              SliverFillRemaining(
//                hasScrollBody: false,
//                child: Center(
//                  child: Text(
//                    "List is empty",
//                    style: TextStyle(
//                      color: Colors.white,
//                    ),
//                  ),
//                ),
//              ),
            FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Transaction> loaded = snapshot.data;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (loaded.length > index)
                          return _buildCard(loaded[index], index);
                        else
                          return null;
                      }, childCount: loaded.length),
                    );
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
                })
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Transaction transaction, index) {
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
                  Text(transaction.received ? "Received $index" : "Sent$index"),
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
//    return Card(
//      elevation: 4,
//      margin: EdgeInsets.only(left: 12, right: 12, top: 12),
//      child: Container(
//        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
//        child: Text("Item $index"),
//      ),
//    );
  }

  Container _transactionIcon(Transaction transaction) {
    return Container(
      child: Icon(transaction.received ? Icons.call_received : Icons.call_made),
      margin: EdgeInsets.only(right: 10),
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

class Header extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final Balance balance;

  const Header({Key key, this.maxHeight, this.minHeight, this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);

        return Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            _buildGradient(animation),
            _buildTitle(animation),
          ],
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }

  Align _buildTitle(Animation<double> animation) {
    return Align(
      alignment: AlignmentTween(
              begin: Alignment.bottomCenter, end: Alignment.bottomLeft)
          .evaluate(animation),
      child: Container(
        margin: EdgeInsets.only(bottom: 12, left: 12),
        child: Text(
          "Balance:\n${balance.nwc} NWC \n${balance.usd} USD",
          style: TextStyle(
            fontSize: Tween<double>(begin: 18, end: 36).evaluate(animation),
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Container _buildGradient(Animation<double> animation) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            ColorTween(begin: Colors.black87, end: Colors.black38)
                .evaluate(animation)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Image _buildImage() {
    return Image.network(
      "https://www.rollingstone.com/wp-content/uploads/2020/02/TheWeeknd.jpg",
      fit: BoxFit.cover,
    );
  }
}
