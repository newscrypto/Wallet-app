class UserBalance {
  final double nwc;
  final double usd;

  UserBalance({this.nwc, this.usd});

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      nwc: json['nwc'],
      usd: json['usd'],
    );
  }
}
