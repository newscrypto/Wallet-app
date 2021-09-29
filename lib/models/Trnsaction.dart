import 'package:intl/intl.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class WalletTransaction {
  final int id;
  final bool received;
  final String amount;
  final String paginationToken;
  final String from;
  final String to;
  final String hash;
  final String createdAt;
  final DateTime dateTime;

  WalletTransaction({
    this.id,
    this.received,
    this.amount,
    this.paginationToken,
    this.from,
    this.to,
    this.createdAt,
    this.hash,
    this.dateTime,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      received: json['received'],
      amount: json['amount'],
    );
  }

  factory WalletTransaction.fromPaymentOperation(
      PaymentOperationResponse payment, String accountId) {
    bool received = accountId == payment.to.accountId;
    print(payment.from.accountId);
    return WalletTransaction(
      id: payment.id,
      amount:
          NumberFormat('###.0#', 'en_US').format(double.parse(payment.amount)),
      paginationToken: payment.pagingToken,
      from: payment.from.accountId,
      to: payment.to.accountId,
      createdAt:
          DateFormat.yMd().add_Hm().format(DateTime.parse(payment.createdAt)),
      hash: payment.transactionHash,
      received: received,
      dateTime: DateTime.parse(payment.createdAt),
    );
  }

  get addressFormat {
    var text = received ? "From: " : "To: ";
    var address = received ? from : to;
    var start = address.substring(0, 7);
    var end = address.substring(address.length - 7);
    return '$text$start...$end';
  }

  get hashFormat {
    var start = hash.substring(0, 7);
    var end = hash.substring(hash.length - 7);
    return '$start...$end';
  }

  get type {
    return received ? "Received" : "Send";
  }

  get url {
    return 'https://stellar.expert/explorer/public/tx/${id - 1}';
  }

  get icon {
    return received ? "deposit" : "withdraw";
  }
}
