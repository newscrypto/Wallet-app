class Balance {
  final double nwc;
  final double usd;

  Balance({this.nwc, this.usd});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      nwc: json['nwc'],
      usd: json['usd'],
    );
  }
}
