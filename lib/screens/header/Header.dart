import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Price.dart';
import 'package:newscrypto_wallet/models/Statistics.dart';
import 'package:newscrypto_wallet/screens/header/widgets/Chart.dart';
import 'package:newscrypto_wallet/services/Acount.dart';
import 'package:newscrypto_wallet/services/PriceHistoryService.dart';

class HeaderState extends StatefulWidget {
  final double maxHeight;
  final double minHeight;

  const HeaderState({Key key, this.maxHeight, this.minHeight})
      : super(key: key);

  @override
  _HeaderState createState() =>
      _HeaderState(maxHeight: maxHeight, minHeight: minHeight);
}

class _HeaderState extends State<HeaderState> {
  final double maxHeight;
  final double minHeight;
  Balance balance = Balance(nwc: 0, usd: 0);
  List<PriceHistory> prices;

  _HeaderState({
    @required this.maxHeight,
    @required this.minHeight,
  });

  @override
  void initState() {
    loadHistory();
    loadBalance();
    super.initState();
  }

  Future<List<PriceHistory>> loadHistory() async {
    var startAt =
        (DateTime.now().subtract(Duration(days: 14)).millisecondsSinceEpoch /
                1000)
            .round();
    List<PriceHistory> _data = await fetchPriceHistory(startAt, "1day");
    setState(() {
      prices = _data;
    });
  }

  Future<List<PriceHistory>> loadBalance() async {
    double nwcBalance = await getAccountBalance();
    Statistics nwcPrice = await fetchStats();
    print(nwcPrice.last);
    setState(() {
      balance = Balance(nwc: nwcBalance, usd: nwcPrice.last * nwcBalance);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        return Stack(
          children: [
            _buildGradient(animation),
            _buildTitle(animation),
            Align(
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: expandRatio,
                  child: chart(context, prices, balance, constraints.maxHeight,
                      animation),
                ))

//                    child: Container(
//                      width: MediaQuery.of(context).size.width * 0.90,
//                      height: maxHeight - 100,
//                      margin: EdgeInsets.only(top: 50),
//                      child: prices != null && prices.isNotEmpty
//                          ? GridlineDashPattern.withSampleData(prices)
//                          : Container(),
//                    ))),
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
      alignment:
          AlignmentTween(begin: Alignment.bottomLeft, end: Alignment.bottomLeft)
              .evaluate(animation),
      child: Container(
          margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                "Balance:",
                style: TextStyle(
                  fontSize:
                      Tween<double>(begin: 14, end: 24).evaluate(animation),
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${balance.nwc.toStringAsFixed(2)} NWC",
                    style: TextStyle(
                      fontSize:
                          Tween<double>(begin: 12, end: 18).evaluate(animation),
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "${balance.usd.toStringAsFixed(2)} USD",
                    style: TextStyle(
                      fontSize:
                          Tween<double>(begin: 12, end: 18).evaluate(animation),
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Container _buildGradient(Animation<double> animation) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            ColorTween(begin: Colors.black12, end: Colors.black38)
                .evaluate(animation)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

//  Widget _buildImage(BuildContext context) {
//    return Container(
//        alignment: Alignment.center,
//        margin: EdgeInsets.only(top: 40),
//        height: maxHeight - 150,
//        width: MediaQuery.of(context).size.width * 0.90,
//        child: SimpleTimeSeriesChart.withSampleData());
////
////    return Image.network(
////      "https://www.rollingstone.com/wp-content/uploads/2020/02/TheWeeknd.jpg",
////      fit: BoxFit.cover,
////    );
//  }

}
