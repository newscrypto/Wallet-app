class ActivationInfo {
  String address;
  String memo;
  double amount;
  bool activated;

  ActivationInfo({
    this.amount,
    this.memo,
    this.address,
    this.activated,
  });

  factory ActivationInfo.fromJson(Map<String, dynamic> json) {
    return ActivationInfo(
      amount: double.parse(json['amount']),
      address: json['address'],
      memo: json['memo'],
      activated: json['activated'],
    );
  }
}
