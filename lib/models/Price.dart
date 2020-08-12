class PriceHistory {
  final double open;
  final double price;
  final double close;
  final double high;
  final double low;
  final double volume;
  final double amount;
  final DateTime date;

  PriceHistory(
      {this.price,
      this.open,
      this.close,
      this.high,
      this.low,
      this.volume,
      this.amount,
      this.date});

  factory PriceHistory.fromJson(List<dynamic> json) {
    return PriceHistory(
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(json[0]) * 1000,
          isUtc: true),
      price: double.parse(json[2]),
      open: double.parse(json[1]),
      close: double.parse(json[2]),
      high: double.parse(json[3]),
      low: double.parse(json[4]),
      amount: double.parse(json[5]),
      volume: double.parse(json[6]),
    );
  }
}
