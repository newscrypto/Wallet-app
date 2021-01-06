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
      last: json["last"] != null ? double.parse(json["last"]) : 0,
      changePrice: json["changePrice"] != null ? double.parse(json["changePrice"]) : 0,
      changeRate: json["changeRate"] != null ? double.parse(json["changeRate"]) : 0,
      high: json["high"] != null ? double.parse(json["high"]) : 0,
      low: json["low"] != null ? double.parse(json["low"]) : 0,
      vol: json["vol"] != null ? double.parse(json["vol"]) : 0,
      buy: json["buy"] != null ? double.parse(json["buy"]) : 0,
      sell: json["sell"] != null ? double.parse(json["sell"]) : 0,
    );
  }
}
