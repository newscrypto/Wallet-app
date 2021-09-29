import 'package:newscrypto_wallet/models/Trnsaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

const ACCOUNT_ID_KEY = "ACCOUNT_ID";
const ACCOUNT_ACTIVATED_KEY = "ACCOUNT_ACTIVATED";
const NEW_TRUSTLINE_KEY = "NEW_TRUSTLINE";
const ACCOUNT_SECRET_KEY = "ACCOUNT_SECRET";
const PIN_CODE_KEY = "PIN_CODE";
const String issuerKey =
    "GDZJD363YP7P3TNYDK3ZD6GLXFMAI3GLVIH7CGFLNZWIZBQUCVE6PTU7";
const String issuerKeyNew =
    "GAAPUOQWOZAG3PENRN7FEPYWXVGJBJVBL6EUE2ZHN5TSY7WBXQDO7AY2";
const String distribution =
    "GBPAWN5KBPN2H4HLOR6SXNDLFBMEORYU4PZ77BK3Z3YK2IRA6HSJWIXL";
const ASSET_CODE = "NWC";

final StellarSDK sdk = StellarSDK.PUBLIC;

class AccountApi {
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

  Future<bool> isNewTrustline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(NEW_TRUSTLINE_KEY)) {
      prefs.setBool(NEW_TRUSTLINE_KEY, false);
    }
    return prefs.getBool(NEW_TRUSTLINE_KEY);
  }

  Future<void> setActivate(bool activate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ACCOUNT_ACTIVATED_KEY, activate);
  }

  Future<String> getStartScreen() async {
    bool login = await isLoginPin();
    bool activated = await isActivated();
    bool isPinSet = (await getPin()) != "";
    if (!activated) return "startScreen";
    if (!isPinSet) return "pinSetup";
    if (login) return "login";
    return "transactions";
  }

  Future<bool> createNWCTrustLine() async {
    String accountSecret = await getAccountSecret();
    Asset nwcAsset = Asset.createNonNativeAsset(ASSET_CODE, issuerKey);
    Asset nwcAssetNew = Asset.createNonNativeAsset(ASSET_CODE, issuerKeyNew);

    KeyPair senderKeyPair = KeyPair.fromSecretSeed(accountSecret);
    AccountResponse sender =
        await sdk.accounts.account(senderKeyPair.accountId);

    String limit = "922337203681";
    ChangeTrustOperation cto =
        ChangeTrustOperationBuilder(nwcAsset, limit).build();
    ChangeTrustOperation ctoNew =
        ChangeTrustOperationBuilder(nwcAssetNew, limit).build();
    Transaction transaction = TransactionBuilder(sender)
        .addOperation(cto)
        .addOperation(ctoNew)
        .build();

    transaction.sign(senderKeyPair, Network.PUBLIC);
    SubmitTransactionResponse response =
        await sdk.submitTransaction(transaction);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(NEW_TRUSTLINE_KEY, true);

    return response.success;
  }

  Future<bool> createNewNWCTrustLine() async {
    bool newTrustLneCreated = await isNewTrustline();
    if (newTrustLneCreated) return true;
    String accountSecret = await getAccountSecret();
    Asset nwcAsset = Asset.createNonNativeAsset(ASSET_CODE, issuerKeyNew);

    KeyPair senderKeyPair = KeyPair.fromSecretSeed(accountSecret);
    AccountResponse sender =
        await sdk.accounts.account(senderKeyPair.accountId);

    String limit = "922337203681";
    ChangeTrustOperation cto =
        ChangeTrustOperationBuilder(nwcAsset, limit).build();
    Transaction transaction =
        TransactionBuilder(sender).addOperation(cto).build();

    transaction.sign(senderKeyPair, Network.PUBLIC);
    SubmitTransactionResponse response =
        await sdk.submitTransaction(transaction);

    print(response.success);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(NEW_TRUSTLINE_KEY, true);
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

  Future<String> getPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PIN_CODE_KEY) ?? "";
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
    print(account);
    for (Balance balance in account.balances) {
      print(balance.assetCode);
      print(balance.balance);

      if (balance.assetCode == ASSET_CODE) {
        nwcBalance += double.parse(balance.balance);
      }
      if (balance.assetIssuer == issuerKey) {
        swapNWC(double.parse(balance.balance));
      }
    }
    print(nwcBalance);
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
          print("transactions added");
          transactions
              .add(new WalletTransaction.fromPaymentOperation(por, accountId));
        }
      }
    }
    print(transactions);
    return transactions;
  }

  Future<List<WalletTransaction>> getAccountNewTransactions(var cursor) async {
    // Request the account data.
    String accountId = await getAccountID();
    Page<OperationResponse> payments = await sdk.payments
        .forAccount(accountId)
        .order(RequestBuilderOrder.ASC)
        .cursor(cursor)
        .limit(10)
        .execute();
    List<WalletTransaction> transactions = [];
    for (OperationResponse response in payments.records) {
      if (response is PaymentOperationResponse) {
        PaymentOperationResponse por = response;
        if (por.transactionSuccessful &&
            por.assetCode == "NWC" &&
            por.to.accountId != issuerKey &&
            por.from.accountId != distribution) {
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
      for (Balance balance in account.balances) {
        print(balance.assetIssuer);
        if (balance.assetIssuer == issuerKeyNew) {
          return true;
        }
      }
      return false;
    } catch (exception) {
      throw "Wrong secret key!";
    }
  }

  Future<bool> sendNWC(String destination, String memo, double amount) async {
    String accountSecret = await getAccountSecret();

    KeyPair senderKeyPair = KeyPair.fromSecretSeed(accountSecret);
    Asset nwcAsset = Asset.createNonNativeAsset("NWC", issuerKeyNew);
// Load sender account data from the stellar network.
    AccountResponse sender =
        await sdk.accounts.account(senderKeyPair.accountId);

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
    SubmitTransactionResponse response =
        await sdk.submitTransaction(transaction);
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
    bool trustline = await checkAddress(keyPair.accountId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(keyPair.accountId);
    setAccountId(keyPair.accountId, prefs);
    setAccountSecret(secretKey, prefs);
    if (!trustline) createNWCTrustLine();
    prefs.setBool(ACCOUNT_ACTIVATED_KEY, true);
    return true;
  }

  Future<bool> swapNWC(double amount) async {
    String accountSecret = await getAccountSecret();

    KeyPair senderKeyPair = KeyPair.fromSecretSeed(accountSecret);
    Asset nwcAsset = Asset.createNonNativeAsset("NWC", issuerKey);
    AccountResponse sender =
        await sdk.accounts.account(senderKeyPair.accountId);

    Transaction transaction = new TransactionBuilder(sender)
        .addOperation(
            PaymentOperationBuilder(issuerKey, nwcAsset, amount.toString())
                .build())
        .addMemo(MemoText("SWAP"))
        .build();

    transaction.sign(senderKeyPair, Network.PUBLIC);

    SubmitTransactionResponse response =
        await sdk.submitTransaction(transaction);
    if (response.success) {
      print("Payment sent");
      return true;
    }
    return false;
  }
}
