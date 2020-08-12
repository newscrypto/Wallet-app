import 'package:newscrypto_wallet/models/Trnsaction.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

String getAccountID() {
  return "GAXVLXETYJFA5J7VCH24JMW5PAYQFBRRATFNORYFAFOZR26SAWLXRN5X";
}
String getAccountSecret() {
  return "SD2ETE2BBUMCFZDTNFAVGU4XSOM63CYQL6ACJE7AVXU6LIGAKJV5DZXW";
}

final StellarSDK sdk = StellarSDK.PUBLIC;

Future<double> getAccountBalance() async {
  // Request the account data.
  AccountResponse account = await sdk.accounts.account(getAccountID());

// You can check the `balance`, `sequence`, `flags`, `signers`, `data` etc.
  double nwcBalance = 0;
  for (Balance balance in account.balances) {
    switch (balance.assetCode) {
      case "NWC":
        nwcBalance = double.parse(balance.balance);
        break;
    }
  }
  return nwcBalance;
}

Future<List<WalletTransaction>> getAccountTransactions(var cursor) async {
  // Request the account data.
  Page<OperationResponse> payments = await sdk.payments
      .forAccount(getAccountID())
      .order(RequestBuilderOrder.DESC)
      .cursor(cursor)
      .limit(10)
      .execute();
  List<WalletTransaction> transactions = [];
  for (OperationResponse response in payments.records) {
    if (response is PaymentOperationResponse) {
      PaymentOperationResponse por = response as PaymentOperationResponse;
      if (por.transactionSuccessful && por.assetCode == "NWC") {
        transactions.add(new WalletTransaction.fromPaymentOperation(por));
        print("Transaction hash: ${por.amount} ${por.pagingToken}");
      }
    }
  }
  return transactions;
}
