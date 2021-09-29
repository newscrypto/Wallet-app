import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Price.dart';
import 'package:newscrypto_wallet/utils/Palete.dart';

Widget chart(BuildContext context, List<PriceHistory> prices, UserBalance balance,
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
            lineColor: Palette.blue,
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
