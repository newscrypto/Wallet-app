class Statistics {
  final double last;
  final double changeRate;
  final double changePrice;
  final double high;
  final double low;
  final double vol;
  final double volValue;
  final double averagePrice;
  final double buy;
  final double sell;

  Statistics({
    this.last,
    this.changeRate,
    this.changePrice,
    this.high,
    this.low,
    this.vol,
    this.volValue,
    this.averagePrice,
    this.buy,
    this.sell,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      last: double.parse(json["last"]),
      changePrice: double.parse(json["changePrice"]),
      changeRate: double.parse(json["changeRate"]),
      high: double.parse(json["high"]),
      low: double.parse(json["low"]),
      vol: double.parse(json["vol"]),
      volValue: double.parse(json["volValue"]),
      averagePrice: double.parse(json["averagePrice"]),
      buy: double.parse(json["buy"]),
      sell: double.parse(json["sell"]),
    );
  }
}
