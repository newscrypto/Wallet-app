import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Price.dart';
import 'package:newscrypto_wallet/screens/Settings/Settings.dart';
import 'package:newscrypto_wallet/screens/header/widgets/Chart.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';

class HeaderState extends StatelessWidget {
  final double maxHeight;
  final double minHeight;
  final UserBalance balance;
  final List<PriceHistory> prices;

  HeaderState({
    @required this.maxHeight,
    @required this.minHeight,
    @required this.balance,
    @required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);
        return SafeArea(
          child: Stack(
            children: [
              _buildTitle(animation, expandRatio),
              Align(
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: expandRatio,
                    child: chart(context, prices, balance,
                        constraints.maxHeight, animation),
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Opacity(
                  opacity: expandRatio,
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings()));
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: Colors.white30,
                ),
              ),
            ],
          ),
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

  Align _buildTitle(Animation<double> animation, expandRatio) {
    if (balance.nwc < 100000)
      return Align(
        alignment: AlignmentTween(
                begin: Alignment.bottomLeft, end: Alignment.bottomLeft)
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
                        Tween<double>(begin: 10, end: 16).evaluate(animation),
                    color: Palette.blue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${balance.nwc.toStringAsFixed(2)} NWC",
                      style: TextStyle(
                        fontSize: Tween<double>(begin: 12, end: 18)
                            .evaluate(animation),
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "${balance.usd.toStringAsFixed(2)} USD",
                      style: TextStyle(
                        fontSize: Tween<double>(begin: 12, end: 18)
                            .evaluate(animation),
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                )
              ],
            )),
      );

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
                      Tween<double>(begin: 10, end: 13).evaluate(animation),
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "${balance.nwc.toStringAsFixed(2)} NWC",
                style: TextStyle(
                  fontSize:
                      Tween<double>(begin: 12, end: 15).evaluate(animation),
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Visibility(
                  visible: expandRatio > 0.4,
                  child: Opacity(
                    opacity: expandRatio,
                    child: Text(
                      "${balance.usd.toStringAsFixed(2)} USD",
                      style: TextStyle(
                        fontSize: Tween<double>(begin: 12, end: 15)
                            .evaluate(animation),
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}
