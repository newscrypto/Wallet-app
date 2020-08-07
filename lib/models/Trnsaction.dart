class Transaction {
  final int id;
  final String name;
  final bool received;
  final double amount;

  Transaction({this.id, this.name, this.received, this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      name: json['name'],
      received: json['received'],
      amount: json['amount'],
    );
  }
}
