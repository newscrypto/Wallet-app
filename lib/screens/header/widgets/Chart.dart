import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_candlesticks/flutter_candlesticks.dart';
import 'package:newscrypto_wallet/models/Balance.dart';
import 'package:newscrypto_wallet/models/Price.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Widget chart(BuildContext context, List<PriceHistory> prices, Balance balance,
    var maxHeight, Animation<double> animation) {
  if (prices == null || prices.isEmpty) {
    return Container();
  }
  DateTime toDate = prices[0].date;
  DateTime fromDate = prices[prices.length - 1].date;
  return Container(
    height: Tween<double>(end: maxHeight - 130, begin: maxHeight - 50)
        .evaluate(animation),
    margin: EdgeInsets.only(
        top: Tween<double>(begin: 0, end: 50).evaluate(animation)),
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
  DateTime toDate = prices[0].date;
  DateTime fromDate = prices[prices.length - 1].date;
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

class GridlineDashPattern extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GridlineDashPattern(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory GridlineDashPattern.withSampleData(List<PriceHistory> prices) {
    return new GridlineDashPattern(
      _createSampleData(prices),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return new charts.TimeSeriesChart(seriesList,
//        animate: animate,
//
//        /// Customize the gridlines to use a dash pattern.
//        primaryMeasureAxis: new charts.NumericAxisSpec(
//            renderSpec: charts.GridlineRendererSpec(
//                lineStyle: charts.LineStyleSpec(
//          dashPattern: [1, 1],
//        ))));
//  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<PriceHistory, DateTime>> _createSampleData(
      List<PriceHistory> prices) {
    return [
      new charts.Series<PriceHistory, DateTime>(
        id: 'Price',
        domainFn: (PriceHistory row, _) => row.date,
        measureFn: (PriceHistory row, _) => row.price * 1000,
        data: prices,
      ),
    ];
  }
}

/// Sample time series data type.
class MyRow {
  final DateTime timeStamp;
  final double cost;

  MyRow(this.timeStamp, this.cost);
}
