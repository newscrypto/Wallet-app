import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Price.dart';

Widget chart(BuildContext context, List<PriceHistory> prices, Balance balance,
    var maxHeight, Animation<double> animation) {
  if (prices == null || prices.isEmpty) {
    return Container();
  }
  DateTime toDate = prices[0].date;
  DateTime fromDate = prices[prices.length - 1].date;
  return Container(
    height: Tween<double>(end: maxHeight - 120, begin: maxHeight - 50)
        .evaluate(animation),
    width: MediaQuery.of(context).size.width,
    child: BezierChart(
      fromDate: fromDate,
      bezierChartScale: BezierChartScale.WEEKLY,
      toDate: toDate,
      selectedDate: toDate,
      series: [
        BezierLine(
            label: "Price",
            onMissingValue: (dateTime) {
              return prices[0].price;
            },
            data: prices
                .map((e) => DataPoint<DateTime>(value: e.price, xAxis: e.date))
                .toList()),
      ],
      config: BezierChartConfig(
        showDataPoints: false,
        verticalIndicatorStrokeWidth: 1.0,
        verticalIndicatorColor: Colors.black26,
        footerHeight: 40.0,
      ),
    ),
  );
}

Widget candlesticks(BuildContext context, List<PriceHistory> prices,
    Balance balance, var maxHeight) {
  if (prices == null || prices.isEmpty) {
    return Container();
  }

  List data = [];
  for (var price in prices) {
    data.add({
      "open": price.open,
      "high": price.high,
      "low": price.low,
      "close": price.close,
      "volumeto": price.volume
    });
  }

  return Container(
    margin: EdgeInsets.only(top: 100),
    height: maxHeight - 200,
    width: MediaQuery.of(context).size.width * 0.9,
    child: OHLCVGraph(data: data, enableGridLines: true, volumeProp: 0.1),
  );
}
