import 'package:newscrypto_wallet/models/Trnsaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

const ACCOUNT_ID_KEY = "ACCOUNT_ID";
const ACCOUNT_ACTIVATED_KEY = "ACCOUNT_ACTIVATED";
const ACCOUNT_SECRET_KEY = "ACCOUNT_SECRET";
const PIN_CODE_KEY = "PIN_CODE";
const String issuerKey =
    "GDZJD363YP7P3TNYDK3ZD6GLXFMAI3GLVIH7CGFLNZWIZBQUCVE6PTU7";
const ASSET_CODE = "NWC";

final StellarSDK sdk = StellarSDK.PUBLIC;

Future<String> getAccountID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(ACCOUNT_ID_KEY)) {
    prefs.setString(ACCOUNT_ID_KEY, "");
  }
  return prefs.getString(ACCOUNT_ID_KEY);
}

Future<String> getAccountSecret() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(ACCOUNT_ID_KEY)) {
    prefs.setString(ACCOUNT_ID_KEY, "");
  }
  return prefs.getString(ACCOUNT_SECRET_KEY);
}

Future<bool> isActivated() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(ACCOUNT_ACTIVATED_KEY)) {
    prefs.setBool(ACCOUNT_ACTIVATED_KEY, false);
  }
  return prefs.getBool(ACCOUNT_ACTIVATED_KEY);
}

Future<void> setActivate(bool activate) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(ACCOUNT_ACTIVATED_KEY, activate);
}

Future<String> getStartScreen() async {
  bool login = await isLoginPin();
  bool activated = await isActivated();
  if (!activated) return "startScreen";
  if (login) return "login";
  return "transactions";
}

Future<bool> createNWCTrustLine() async {
  String accountSecret = await getAccountSecret();
  Asset nwcAsset = Asset.createNonNativeAsset(ASSET_CODE, issuerKey);

  KeyPair senderKeyPair = KeyPair.fromSecretSeed(accountSecret);
  AccountResponse sender = await sdk.accounts.account(senderKeyPair.accountId);

  String limit = "922337203681";
  ChangeTrustOperation cto =
      ChangeTrustOperationBuilder(nwcAsset, limit).build();
  Transaction transaction =
      TransactionBuilder(sender).addOperation(cto).build();

  transaction.sign(senderKeyPair, Network.PUBLIC);
  SubmitTransactionResponse response = await sdk.submitTransaction(transaction);

  print(response.success);
  return response.success;
}

void setAccountId(String accountId, SharedPreferences prefs) {
  prefs.setString(ACCOUNT_ID_KEY, accountId);
}

void setAccountSecret(String accountSecret, SharedPreferences prefs) {
  prefs.setString(ACCOUNT_SECRET_KEY, accountSecret);
}

Future<void> setPin(String pinCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(PIN_CODE_KEY, pinCode);
}

Future<bool> comparePin(String pinCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String pin = prefs.getString(PIN_CODE_KEY);
  return pin == pinCode;
}

Future<bool> isLoginPin() async {
  String pinSettingKey = "balancePin";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool pin = true;
  if (prefs.containsKey(pinSettingKey))
    pin = prefs.getBool(pinSettingKey);
  else
    prefs.setBool(pinSettingKey, true);

  return pin;
}

Future<String> createNewWallet() async {
  String accountId = await getAccountID();
  if (accountId.isEmpty) {
    KeyPair keyPair = KeyPair.random();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setAccountSecret(keyPair.secretSeed, prefs);
    setAccountId(keyPair.accountId, prefs);
    return keyPair.accountId;
  }
  return accountId;
}

Future<double> getAccountBalance() async {
  // Request the account data.
  String accountId = await getAccountID();
  AccountResponse account = await sdk.accounts.account(accountId);

// You can check the `balance`, `sequence`, `flags`, `signers`, `data` etc.
  double nwcBalance = 0;
  for (Balance balance in account.balances) {
    switch (balance.assetIssuer) {
      case issuerKey:
        nwcBalance = double.parse(balance.balance);
        break;
    }
  }
  return nwcBalance;
}

Future<List<WalletTransaction>> getAccountTransactions(var cursor) async {
  // Request the account data.
  String accountId = await getAccountID();
  Page<OperationResponse> payments = await sdk.payments
      .forAccount(accountId)
      .order(RequestBuilderOrder.DESC)
      .cursor(cursor)
      .limit(10)
      .execute();
  List<WalletTransaction> transactions = [];
  for (OperationResponse response in payments.records) {
    if (response is PaymentOperationResponse) {
      PaymentOperationResponse por = response;
      if (por.transactionSuccessful && por.assetCode == "NWC") {
        transactions
            .add(new WalletTransaction.fromPaymentOperation(por, accountId));
      }
    }
  }
  return transactions;
}

Future<bool> checkAddress(String address) async {
  print(address);
  try {
    AccountResponse account = await sdk.accounts.account(address);
    print(account.balances);
    for (Balance balance in account.balances) {
      print(balance.assetIssuer);
      if (balance.assetIssuer == issuerKey) {
        return true;
      }
    }
    return false;
  } catch (exception) {
    return false;
  }
}

Future<bool> sendNWC(String destination, String memo, double amount) async {
  String accountSecret = await getAccountSecret();

  KeyPair senderKeyPair = KeyPair.fromSecretSeed(accountSecret);
  Asset nwcAsset = Asset.createNonNativeAsset("NWC", issuerKey);
// Load sender account data from the stellar network.
  AccountResponse sender = await sdk.accounts.account(senderKeyPair.accountId);

// Build the transaction to send 100 XLM native payment from sender to destination
  Transaction transaction = new TransactionBuilder(sender)
      .addOperation(
          PaymentOperationBuilder(destination, nwcAsset, amount.toString())
              .build())
      .addMemo(MemoText(memo))
      .build();

// Sign the transaction with the sender's key pair.
  transaction.sign(senderKeyPair, Network.PUBLIC);

// Submit the transaction to the stellar network.
  SubmitTransactionResponse response = await sdk.submitTransaction(transaction);
  if (response.success) {
    print("Payment sent");
    return true;
  }
  return false;
}

Future<bool> importNewWallet(String secretKey) async {
  KeyPair keyPair;
  print(secretKey);
  try {
    keyPair = KeyPair.fromSecretSeed(secretKey);
  } catch (exception) {
    print(exception);
    throw "Wrong secret key!";
  }
  if (!await checkAddress(keyPair.accountId)) throw "No trustline for NWC!";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(keyPair.accountId);
  setAccountId(keyPair.accountId, prefs);
  setAccountSecret(secretKey, prefs);
  return true;
}
